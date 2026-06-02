import 'dart:convert';
import 'dart:io';

import 'package:ffan/features/communication/data/vocabulary_loader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Map<String, dynamic> json;

  setUp(() {
    final raw = File('test/fixtures/mini_vocab.json').readAsStringSync();
    json = jsonDecode(raw) as Map<String, dynamic>;
  });

  test('parses grid dimensions and metadata', () {
    final vocab = VocabularyLoader.fromJson(json);
    expect(vocab.id, 'mini');
    expect(vocab.language, 'en-US');
    expect(vocab.rows, 1);
    expect(vocab.cols, 2);
    expect(vocab.rootFolderId, 'root');
  });

  test('parses word, folder, and empty cells', () {
    final vocab = VocabularyLoader.fromJson(json);
    final root = vocab.cellsFor('root');
    expect(root, hasLength(2));

    final word = root.firstWhere((c) => c.isWord);
    expect(word.label, 'hi');
    expect(word.symbol, 'hi');
    expect(word.colorHex, 0xFF81C784);

    final folder = root.firstWhere((c) => c.isFolder);
    expect(folder.targetFolderId, 'more');

    final more = vocab.cellsFor('more');
    expect(more.any((c) => c.isEmpty), isTrue);
  });

  test('unknown cell type throws FormatException', () {
    final bad = {
      ...json,
      'folders': {
        'root': [
          {'type': 'wormhole', 'row': 0, 'col': 0}
        ]
      }
    };
    expect(() => VocabularyLoader.fromJson(bad), throwsFormatException);
  });
}
