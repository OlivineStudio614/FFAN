import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/utterance.dart';
import 'analytics_service.dart';
import 'providers.dart';
import 'tts_service.dart';

class UtteranceController extends Notifier<Utterance> {
  @override
  Utterance build() => const Utterance.empty();

  TtsService get _tts => ref.read(ttsServiceProvider);
  AnalyticsService get _analytics => ref.read(analyticsServiceProvider);

  void addWord(UtteranceToken token) {
    state = state.add(token);
    _analytics.logWordSelected(token.message);
  }

  void backspace() => state = state.backspace();

  void clear() => state = state.clear();

  Future<void> speak() async {
    if (state.isEmpty) return;
    try {
      await _tts.speak(state.text);
      _analytics.logMessageSpoken(state.tokens.length);
    } catch (error) {
      // A TTS failure must never crash the app or leave an unhandled async
      // error — speaking is the primary action, so degrade gracefully.
      debugPrint('TTS speak failed: $error');
    }
  }
}

final utteranceControllerProvider =
    NotifierProvider<UtteranceController, Utterance>(UtteranceController.new);
