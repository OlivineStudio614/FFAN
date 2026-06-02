import 'package:ffan/features/communication/domain/cell.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('word cell exposes label, message, symbol, color', () {
    const cell = Cell.word(
      row: 1,
      col: 2,
      label: 'apple',
      message: 'apple',
      symbol: 'apple',
      colorHex: 0xFFA5D6A7,
    );
    expect(cell.row, 1);
    expect(cell.col, 2);
    expect(cell.isWord, isTrue);
    expect(cell.isFolder, isFalse);
    expect(cell.isEmpty, isFalse);
    expect(cell.label, 'apple');
    expect(cell.message, 'apple');
    expect(cell.symbol, 'apple');
  });

  test('folder cell exposes target folder id', () {
    const cell = Cell.folder(
      row: 0,
      col: 0,
      label: 'Food',
      symbol: 'food',
      colorHex: 0xFFFFF59D,
      targetFolderId: 'food',
    );
    expect(cell.isFolder, isTrue);
    expect(cell.targetFolderId, 'food');
  });

  test('empty cell is empty', () {
    const cell = Cell.empty(row: 5, col: 6);
    expect(cell.isEmpty, isTrue);
    expect(cell.isWord, isFalse);
    expect(cell.isFolder, isFalse);
  });
}
