import '../domain/cell.dart';
import '../domain/vocabulary.dart';

/// Pure JSON -> Vocabulary parser. No I/O, so it is trivially testable.
class VocabularyLoader {
  const VocabularyLoader._();

  static Vocabulary fromJson(Map<String, dynamic> json) {
    final foldersJson = json['folders'] as Map<String, dynamic>;
    final folders = <String, List<Cell>>{};
    for (final entry in foldersJson.entries) {
      final cells = (entry.value as List)
          .map((c) => _cellFromJson(c as Map<String, dynamic>))
          .toList(growable: false);
      folders[entry.key] = cells;
    }

    return Vocabulary(
      id: json['id'] as String,
      name: json['name'] as String,
      language: json['language'] as String,
      rows: json['rows'] as int,
      cols: json['cols'] as int,
      rootFolderId: json['rootFolderId'] as String? ?? 'root',
      folders: folders,
    );
  }

  static Cell _cellFromJson(Map<String, dynamic> json) {
    final row = json['row'] as int;
    final col = json['col'] as int;
    switch (json['type'] as String) {
      case 'word':
        return Cell.word(
          row: row,
          col: col,
          label: json['label'] as String,
          message: json['message'] as String,
          symbol: json['symbol'] as String,
          colorHex: _parseColor(json['color'] as String),
        );
      case 'folder':
        return Cell.folder(
          row: row,
          col: col,
          label: json['label'] as String,
          symbol: json['symbol'] as String,
          colorHex: _parseColor(json['color'] as String),
          targetFolderId: json['targetFolderId'] as String,
        );
      case 'empty':
        return Cell.empty(row: row, col: col);
      default:
        throw FormatException('Unknown cell type: ${json['type']}');
    }
  }

  static int _parseColor(String hex) => int.parse(hex);
}
