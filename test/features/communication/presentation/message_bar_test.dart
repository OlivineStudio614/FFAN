import 'package:ffan/features/communication/domain/utterance.dart';
import 'package:ffan/features/communication/presentation/widgets/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows tokens and fires speak/backspace/clear', (tester) async {
    var spoke = 0, back = 0, cleared = 0;
    final utterance = const Utterance.empty()
        .add(const UtteranceToken(message: 'I', symbol: 'I'))
        .add(const UtteranceToken(message: 'want', symbol: 'want'));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: MessageBar(
          utterance: utterance,
          manifest: const {},
          onSpeak: () => spoke++,
          onBackspace: () => back++,
          onClear: () => cleared++,
        ),
      ),
    ));

    expect(find.text('I'), findsWidgets);
    expect(find.text('want'), findsWidgets);

    await tester.tap(find.byKey(const Key('speak')));
    await tester.tap(find.byKey(const Key('backspace')));
    await tester.tap(find.byKey(const Key('clear')));
    await tester.pump();

    expect(spoke, 1);
    expect(back, 1);
    expect(cleared, 1);
  });
}
