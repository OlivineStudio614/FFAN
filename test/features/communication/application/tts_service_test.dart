import 'package:ffan/features/communication/application/tts_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingTts implements TtsService {
  final List<String> spoken = [];
  String? language;
  bool stopped = false;

  @override
  Future<void> setLanguage(String tag) async => language = tag;

  @override
  Future<void> speak(String text) async => spoken.add(text);

  @override
  Future<void> stop() async => stopped = true;
}

void main() {
  test('TtsService contract: setLanguage, speak, stop are awaitable', () async {
    final tts = _RecordingTts();
    await tts.setLanguage('en-US');
    await tts.speak('hello');
    await tts.stop();
    expect(tts.language, 'en-US');
    expect(tts.spoken, ['hello']);
    expect(tts.stopped, isTrue);
  });
}
