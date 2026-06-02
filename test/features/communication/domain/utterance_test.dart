import 'package:ffan/features/communication/domain/utterance.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('empty utterance has no tokens and empty text', () {
    const u = Utterance.empty();
    expect(u.tokens, isEmpty);
    expect(u.isEmpty, isTrue);
    expect(u.text, '');
  });

  test('adding tokens builds space-joined text', () {
    final u = const Utterance.empty()
        .add(const UtteranceToken(message: 'I', symbol: 'i'))
        .add(const UtteranceToken(message: 'want', symbol: 'want'));
    expect(u.tokens.length, 2);
    expect(u.text, 'I want');
    expect(u.isEmpty, isFalse);
  });

  test('backspace removes the last token', () {
    final u = const Utterance.empty()
        .add(const UtteranceToken(message: 'I', symbol: 'i'))
        .add(const UtteranceToken(message: 'want', symbol: 'want'))
        .backspace();
    expect(u.text, 'I');
  });

  test('backspace on empty is a no-op', () {
    expect(const Utterance.empty().backspace().tokens, isEmpty);
  });

  test('clear empties the utterance', () {
    final u = const Utterance.empty()
        .add(const UtteranceToken(message: 'hi', symbol: 'hi'))
        .clear();
    expect(u.isEmpty, isTrue);
  });
}
