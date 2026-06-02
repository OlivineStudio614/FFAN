import 'package:flutter_tts/flutter_tts.dart';

import 'tts_service.dart';

/// Real implementation backed by the device's TTS engine.
class FlutterTtsService implements TtsService {
  FlutterTtsService([FlutterTts? tts]) : _tts = tts ?? FlutterTts();

  final FlutterTts _tts;

  @override
  Future<void> setLanguage(String bcp47Tag) async {
    await _tts.setLanguage(bcp47Tag);
  }

  @override
  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    await _tts.stop();
    await _tts.speak(text);
  }

  @override
  Future<void> stop() async {
    await _tts.stop();
  }
}
