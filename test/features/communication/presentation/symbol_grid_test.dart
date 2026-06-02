import 'package:ffan/features/communication/domain/cell.dart';
import 'package:ffan/features/communication/presentation/widgets/cell_button.dart';
import 'package:ffan/features/communication/presentation/widgets/symbol_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders a button per non-empty cell and fires callbacks',
      (tester) async {
    final tapped = <String>[];
    final opened = <String>[];
    const cells = [
      Cell.word(row: 0, col: 0, label: 'I', message: 'I', symbol: 'I', colorHex: 0xFFFFF176),
      Cell.folder(row: 0, col: 1, label: 'Food', symbol: 'food', colorHex: 0xFFFFCC80, targetFolderId: 'food'),
      Cell.empty(row: 0, col: 2),
    ];

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SymbolGrid(
          rows: 1,
          cols: 3,
          cells: cells,
          manifest: const {},
          onWordTap: (c) => tapped.add(c.message),
          onFolderTap: (c) => opened.add(c.targetFolderId!),
        ),
      ),
    ));

    expect(find.byType(CellButton), findsNWidgets(3));

    await tester.tap(find.text('I').first);
    await tester.tap(find.text('Food').first);
    await tester.pump();

    expect(tapped, ['I']);
    expect(opened, ['food']);
  });
}
