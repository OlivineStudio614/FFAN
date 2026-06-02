import 'package:flutter/material.dart';

import '../../domain/cell.dart';
import 'cell_button.dart';

/// A fixed rows x cols grid. Cells are placed at their immutable (row, col),
/// so a word is always in the same spot (motor planning).
class SymbolGrid extends StatelessWidget {
  const SymbolGrid({
    super.key,
    required this.rows,
    required this.cols,
    required this.cells,
    required this.manifest,
    required this.onWordTap,
    required this.onFolderTap,
  });

  final int rows;
  final int cols;
  final List<Cell> cells;
  final Map<String, String> manifest;
  final void Function(Cell cell) onWordTap;
  final void Function(Cell cell) onFolderTap;

  @override
  Widget build(BuildContext context) {
    // Build a position-indexed lookup so order in JSON doesn't matter.
    final byPos = <int, Cell>{
      for (final c in cells) c.row * cols + c.col: c,
    };

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: rows * cols,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final cell = byPos[index] ??
            Cell.empty(row: index ~/ cols, col: index % cols);
        return CellButton(
          cell: cell,
          manifest: manifest,
          onTap: switch (cell.type) {
            CellType.word => () => onWordTap(cell),
            CellType.folder => () => onFolderTap(cell),
            CellType.empty => null,
          },
        );
      },
    );
  }
}
