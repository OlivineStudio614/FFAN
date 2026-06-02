import 'package:flutter/material.dart';

/// Renders a word's ARASAAC pictogram if one was fetched (present in the
/// manifest); otherwise falls back to the label text so the cell is always
/// usable even when a symbol is missing.
class SymbolView extends StatelessWidget {
  const SymbolView({
    super.key,
    required this.symbol,
    required this.label,
    required this.manifest,
  });

  /// ARASAAC search term (key into [manifest]).
  final String? symbol;
  final String label;

  /// term -> asset filename (loaded from assets/symbols/manifest.json).
  final Map<String, String> manifest;

  @override
  Widget build(BuildContext context) {
    final file = symbol == null ? null : manifest[symbol];
    if (file == null) {
      return Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }
    return Image.asset('assets/symbols/$file', fit: BoxFit.contain);
  }
}
