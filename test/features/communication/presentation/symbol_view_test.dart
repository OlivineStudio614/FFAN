import 'package:ffan/features/communication/presentation/widgets/symbol_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('falls back to label text when no manifest entry', (tester) async {
    await tester.pumpWidget(_wrap(
      const SymbolView(symbol: 'nonexistent', label: 'good', manifest: {}),
    ));
    expect(find.text('good'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('renders an Image when the manifest has the symbol', (tester) async {
    await tester.pumpWidget(_wrap(
      const SymbolView(
        symbol: 'apple',
        label: 'apple',
        manifest: {'apple': 'apple.png'},
      ),
    ));
    expect(find.byType(Image), findsOneWidget);
  });
}
