import 'package:flutter/material.dart';

import '../../domain/utterance.dart';
import 'symbol_view.dart';

/// The utterance strip at the top of the board: shows selected words as
/// symbol chips with speak / backspace / clear controls.
class MessageBar extends StatelessWidget {
  const MessageBar({
    super.key,
    required this.utterance,
    required this.manifest,
    required this.onSpeak,
    required this.onBackspace,
    required this.onClear,
  });

  final Utterance utterance;
  final Map<String, String> manifest;
  final VoidCallback onSpeak;
  final VoidCallback onBackspace;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: utterance.tokens.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, i) {
                final t = utterance.tokens[i];
                return SizedBox(
                  width: 72,
                  child: Column(
                    children: [
                      Expanded(
                        child: SymbolView(
                          symbol: t.symbol,
                          label: t.message,
                          manifest: manifest,
                        ),
                      ),
                      Text(t.message,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
          ),
          IconButton(
            key: const Key('speak'),
            iconSize: 36,
            tooltip: 'Speak',
            icon: const Icon(Icons.volume_up),
            onPressed: onSpeak,
          ),
          IconButton(
            key: const Key('backspace'),
            iconSize: 32,
            tooltip: 'Delete last',
            icon: const Icon(Icons.backspace_outlined),
            onPressed: onBackspace,
          ),
          IconButton(
            key: const Key('clear'),
            iconSize: 32,
            tooltip: 'Clear',
            icon: const Icon(Icons.delete_outline),
            onPressed: onClear,
          ),
        ],
      ),
    );
  }
}
