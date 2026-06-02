import 'package:flutter/foundation.dart';

/// One selected word in the message bar.
@immutable
class UtteranceToken {
  const UtteranceToken({required this.message, required this.symbol});

  /// Text that gets spoken.
  final String message;

  /// ARASAAC search term used to render the thumbnail.
  final String symbol;

  @override
  bool operator ==(Object other) =>
      other is UtteranceToken &&
      other.message == message &&
      other.symbol == symbol;

  @override
  int get hashCode => Object.hash(message, symbol);
}

/// The ordered list of words currently in the message bar. Immutable: each
/// mutation returns a new instance (drives Riverpod state updates cleanly).
@immutable
class Utterance {
  const Utterance(this.tokens);
  const Utterance.empty() : tokens = const [];

  final List<UtteranceToken> tokens;

  bool get isEmpty => tokens.isEmpty;

  /// Space-joined spoken form.
  String get text => tokens.map((t) => t.message).join(' ');

  Utterance add(UtteranceToken token) => Utterance([...tokens, token]);

  Utterance backspace() => isEmpty
      ? this
      : Utterance(tokens.sublist(0, tokens.length - 1));

  Utterance clear() => const Utterance.empty();
}
