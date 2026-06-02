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

    return Scaffold(
      body: SafeArea(
        child: vocabAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Failed to load vocabulary: $e')),
          data: (vocab) {
            final manifest = manifestAsync.value ?? const {};
            final cells = vocab.cellsFor(board.currentFolderId);
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
                _NavBar(board: board, vocabName: vocab.name),
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
  const _NavBar({required this.board, required this.vocabName});

  final BoardState board;
  final String vocabName;

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
          Text(board.currentFolderId == 'root' ? vocabName : board.currentFolderId,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
