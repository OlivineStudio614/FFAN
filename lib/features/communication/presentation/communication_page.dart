import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/board_controller.dart';
import '../application/providers.dart';
import '../application/utterance_controller.dart';
import '../domain/utterance.dart';
import 'widgets/message_bar.dart';
import 'widgets/symbol_grid.dart';

class CommunicationPage extends ConsumerWidget {
  const CommunicationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vocabAsync = ref.watch(vocabularyProvider);
    final manifestAsync = ref.watch(symbolManifestProvider);
    final board = ref.watch(boardControllerProvider);
    final utterance = ref.watch(utteranceControllerProvider);

    // Match the speech engine's voice to the vocabulary's language once it
    // loads, so TTS speaks the vocabulary's locale rather than the device's.
    ref.listen(vocabularyProvider, (previous, next) {
      final vocab = next.value;
      if (vocab != null) {
        ref.read(ttsServiceProvider).setLanguage(vocab.language);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: vocabAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Failed to load vocabulary: $e')),
          data: (vocab) {
            final manifest = manifestAsync.value ?? const {};
            final cells = vocab.cellsFor(board.currentFolderId);
            // Breadcrumb: show the folder's display label (e.g. "Food"), not
            // its raw id ("food"). Folders are opened from the root board.
            String title = vocab.name;
            if (board.currentFolderId != vocab.rootFolderId) {
              title = board.currentFolderId;
              for (final c in vocab.cellsFor(vocab.rootFolderId)) {
                if (c.isFolder && c.targetFolderId == board.currentFolderId) {
                  title = c.label;
                  break;
                }
              }
            }
            return Column(
              children: [
                MessageBar(
                  utterance: utterance,
                  manifest: manifest,
                  onSpeak: () =>
                      ref.read(utteranceControllerProvider.notifier).speak(),
                  onBackspace: () => ref
                      .read(utteranceControllerProvider.notifier)
                      .backspace(),
                  onClear: () =>
                      ref.read(utteranceControllerProvider.notifier).clear(),
                ),
                _NavBar(board: board, title: title),
                Expanded(
                  child: SymbolGrid(
                    rows: vocab.rows,
                    cols: vocab.cols,
                    cells: cells,
                    manifest: manifest,
                    onWordTap: (cell) => ref
                        .read(utteranceControllerProvider.notifier)
                        .addWord(UtteranceToken(
                          message: cell.message,
                          symbol: cell.symbol ?? cell.label,
                        )),
                    onFolderTap: (cell) => ref
                        .read(boardControllerProvider.notifier)
                        .openFolder(cell.targetFolderId!),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NavBar extends ConsumerWidget {
  const _NavBar({required this.board, required this.title});

  final BoardState board;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        children: [
          IconButton(
            tooltip: 'Back',
            icon: const Icon(Icons.arrow_back),
            onPressed: board.canGoBack
                ? () => ref.read(boardControllerProvider.notifier).goBack()
                : null,
          ),
          IconButton(
            tooltip: 'Home',
            icon: const Icon(Icons.home_outlined),
            onPressed: board.canGoBack
                ? () => ref.read(boardControllerProvider.notifier).goHome()
                : null,
          ),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
