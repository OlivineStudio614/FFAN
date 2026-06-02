/// Text-to-speech abstraction. Implementations are injected so the UI/logic
/// can be tested without touching the platform.
abstract interface class TtsService {
  Future<void> setLanguage(String bcp47Tag);
  Future<void> speak(String text);
  Future<void> stop();
}
