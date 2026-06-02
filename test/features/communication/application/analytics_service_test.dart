import 'package:ffan/features/communication/application/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingAnalytics implements AnalyticsService {
  final List<String> events = [];
  @override
  void logSessionStart() => events.add('session_start');
  @override
  void logWordSelected(String word) => events.add('word:$word');
  @override
  void logFolderOpened(String folderId) => events.add('folder:$folderId');
  @override
  void logMessageSpoken(int wordCount) => events.add('spoken:$wordCount');
}

void main() {
  test('analytics records the four Phase 1 events', () {
    final a = _RecordingAnalytics()
      ..logSessionStart()
      ..logWordSelected('want')
      ..logFolderOpened('food')
      ..logMessageSpoken(2);
    expect(a.events, ['session_start', 'word:want', 'folder:food', 'spoken:2']);
  });

  test('DebugAnalyticsService satisfies the interface without throwing', () {
    const a = DebugAnalyticsService();
    expect(() {
      a
        ..logSessionStart()
        ..logWordSelected('go')
        ..logFolderOpened('drinks')
        ..logMessageSpoken(1);
    }, returnsNormally);
  });
}
