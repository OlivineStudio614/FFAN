import 'package:ffan/features/communication/application/analytics_service.dart';
import 'package:ffan/features/communication/application/providers.dart';
import 'package:ffan/features/communication/application/tts_service.dart';
import 'package:ffan/features/communication/application/utterance_controller.dart';
import 'package:ffan/features/communication/domain/utterance.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTts implements TtsService {
  final List<String> spoken = [];
  String? lang;
  @override
  Future<void> setLanguage(String tag) async => lang = tag;
  @override
  Future<void> speak(String text) async => spoken.add(text);
  @override
  Future<void> stop() async {}
}

class _FakeAnalytics implements AnalyticsService {
  int spokenCount = -1;
  final List<String> words = [];
  @override
  void logSessionStart() {}
  @override
  void logWordSelected(String word) => words.add(word);
  @override
  void logFolderOpened(String folderId) {}
  @override
  void logMessageSpoken(int wordCount) => spokenCount = wordCount;
}

ProviderContainer _container(_FakeTts tts, _FakeAnalytics analytics) {
  return ProviderContainer(overrides: [
    ttsServiceProvider.overrideWithValue(tts),
    analyticsServiceProvider.overrideWithValue(analytics),
  ]);
}

void main() {
  test('addWord appends a token and logs selection', () {
    final c = _container(_FakeTts(), _FakeAnalytics());
    addTearDown(c.dispose);
    c.read(utteranceControllerProvider.notifier).addWord(
          const UtteranceToken(message: 'I', symbol: 'I'),
        );
    expect(c.read(utteranceControllerProvider).text, 'I');
  });

  test('backspace and clear mutate state', () {
    final c = _container(_FakeTts(), _FakeAnalytics());
    addTearDown(c.dispose);
    final ctrl = c.read(utteranceControllerProvider.notifier)
      ..addWord(const UtteranceToken(message: 'I', symbol: 'I'))
      ..addWord(const UtteranceToken(message: 'go', symbol: 'go'));
    ctrl.backspace();
    expect(c.read(utteranceControllerProvider).text, 'I');
    ctrl.clear();
    expect(c.read(utteranceControllerProvider).isEmpty, isTrue);
  });

  test('speak sends joined text to TTS and logs word count', () async {
    final tts = _FakeTts();
    final analytics = _FakeAnalytics();
    final c = _container(tts, analytics);
    addTearDown(c.dispose);
    final ctrl = c.read(utteranceControllerProvider.notifier)
      ..addWord(const UtteranceToken(message: 'I', symbol: 'I'))
      ..addWord(const UtteranceToken(message: 'want', symbol: 'want'));
    await ctrl.speak();
    expect(tts.spoken, ['I want']);
    expect(analytics.spokenCount, 2);
  });

  test('speak on empty utterance does nothing', () async {
    final tts = _FakeTts();
    final c = _container(tts, _FakeAnalytics());
    addTearDown(c.dispose);
    await c.read(utteranceControllerProvider.notifier).speak();
    expect(tts.spoken, isEmpty);
  });
}
