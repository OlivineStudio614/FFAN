import 'cell.dart';

/// A named, fixed-size symbol set. A vocabulary is a map of folder id -> the
/// cells in that folder. Every folder shares the same grid dimensions so word
/// positions stay consistent (motor planning).
class Vocabulary {
  const Vocabulary({
    required this.id,
    required this.name,
    required this.language,
    required this.rows,
    required this.cols,
    required this.folders,
    this.rootFolderId = 'root',
  });

  final String id;
  final String name;

  /// BCP-47 tag passed to TTS, e.g. 'en-US'.
  final String language;
  final int rows;
  final int cols;

  /// folderId -> cells in that folder.
  final Map<String, List<Cell>> folders;
  final String rootFolderId;

  List<Cell> cellsFor(String folderId) => folders[folderId] ?? const [];
}
