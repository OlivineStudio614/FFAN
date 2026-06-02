import 'package:flutter/foundation.dart';

/// Anonymized behavioral analytics. NO utterance content is ever sent — only
/// event names and counts. A real Firebase implementation replaces
/// [DebugAnalyticsService] in a later phase without touching feature code.
abstract interface class AnalyticsService {
  void logSessionStart();
  void logWordSelected(String word);
  void logFolderOpened(String folderId);
  void logMessageSpoken(int wordCount);
}

/// Logs to the debug console. Used until Firebase is wired up.
class DebugAnalyticsService implements AnalyticsService {
  const DebugAnalyticsService();

  void _log(String event) => debugPrint('[analytics] $event');

  @override
  void logSessionStart() => _log('session_start');
  @override
  void logWordSelected(String word) => _log('word_selected');
  @override
  void logFolderOpened(String folderId) => _log('folder_opened:$folderId');
  @override
  void logMessageSpoken(int wordCount) => _log('message_spoken n=$wordCount');
}
