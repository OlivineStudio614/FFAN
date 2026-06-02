/// The kind of thing occupying a grid position.
enum CellType { word, folder, empty }

/// A single grid position. Its (row, col) is immutable — the motor-planning
/// guarantee: a word never moves once placed.
class Cell {
  const Cell._({
    required this.type,
    required this.row,
    required this.col,
    this.label = '',
    this.message = '',
    this.symbol,
    this.colorHex,
    this.targetFolderId,
  });

  const Cell.word({
    required int row,
    required int col,
    required String label,
    required String message,
    required String symbol,
    required int colorHex,
  }) : this._(
          type: CellType.word,
          row: row,
          col: col,
          label: label,
          message: message,
          symbol: symbol,
          colorHex: colorHex,
        );

  const Cell.folder({
    required int row,
    required int col,
    required String label,
    required String symbol,
    required int colorHex,
    required String targetFolderId,
  }) : this._(
          type: CellType.folder,
          row: row,
          col: col,
          label: label,
          symbol: symbol,
          colorHex: colorHex,
          targetFolderId: targetFolderId,
        );

  const Cell.empty({required int row, required int col})
      : this._(type: CellType.empty, row: row, col: col);

  final CellType type;
  final int row;
  final int col;
  final String label;
  final String message;
  final String? symbol;
  final int? colorHex;
  final String? targetFolderId;

  bool get isWord => type == CellType.word;
  bool get isFolder => type == CellType.folder;
  bool get isEmpty => type == CellType.empty;
}
