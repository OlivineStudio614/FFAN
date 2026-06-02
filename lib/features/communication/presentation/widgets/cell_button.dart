import 'package:flutter/material.dart';

import '../../domain/cell.dart';
import 'symbol_view.dart';

/// One grid position. Word/folder cells are tappable tiles; empty cells render
/// blank but still occupy their fixed position.
class CellButton extends StatelessWidget {
  const CellButton({
    super.key,
    required this.cell,
    required this.manifest,
    this.onTap,
  });

  final Cell cell;
  final Map<String, String> manifest;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (cell.isEmpty) {
      return const SizedBox.shrink();
    }
    final color = Color(cell.colorHex ?? 0xFFEEEEEE);
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Semantics(
            label: cell.label,
            button: true,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: SymbolView(
                    symbol: cell.symbol,
                    label: cell.label,
                    manifest: manifest,
                  ),
                ),
                if (cell.isFolder)
                  const Positioned(
                    top: 4,
                    right: 4,
                    child: Icon(Icons.folder, size: 18),
                  ),
                Positioned(
                  bottom: 2,
                  left: 0,
                  right: 0,
                  child: Text(
                    cell.label,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
