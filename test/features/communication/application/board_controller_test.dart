import 'package:ffan/features/communication/application/analytics_service.dart';
import 'package:ffan/features/communication/application/board_controller.dart';
import 'package:ffan/features/communication/application/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAnalytics implements AnalyticsService {
  final List<String> opened = [];
  @override
  void logSessionStart() {}
  @override
  void logWordSelected(String word) {}
  @override
  void logFolderOpened(String folderId) => opened.add(folderId);
  @override
  void logMessageSpoken(int wordCount) {}
}

ProviderContainer _container(_FakeAnalytics analytics) => ProviderContainer(
      overrides: [analyticsServiceProvider.overrideWithValue(analytics)],
    );

void main() {
  test('starts at root', () {
    final c = _container(_FakeAnalytics());
    addTearDown(c.dispose);
    final state = c.read(boardControllerProvider);
    expect(state.currentFolderId, 'root');
    expect(state.canGoBack, isFalse);
  });

  test('openFolder pushes and logs; goBack pops', () {
    final analytics = _FakeAnalytics();
    final c = _container(analytics);
    addTearDown(c.dispose);
    final ctrl = c.read(boardControllerProvider.notifier)..openFolder('food');
    expect(c.read(boardControllerProvider).currentFolderId, 'food');
    expect(c.read(boardControllerProvider).canGoBack, isTrue);
    expect(analytics.opened, ['food']);

    ctrl.goBack();
    expect(c.read(boardControllerProvider).currentFolderId, 'root');
    expect(c.read(boardControllerProvider).canGoBack, isFalse);
  });

  test('goBack at root is a no-op', () {
    final c = _container(_FakeAnalytics());
    addTearDown(c.dispose);
    c.read(boardControllerProvider.notifier).goBack();
    expect(c.read(boardControllerProvider).currentFolderId, 'root');
  });

  test('goHome clears back to root', () {
    final c = _container(_FakeAnalytics());
    addTearDown(c.dispose);
    final ctrl = c.read(boardControllerProvider.notifier)
      ..openFolder('food')
      ..openFolder('drinks');
    ctrl.goHome();
    expect(c.read(boardControllerProvider).currentFolderId, 'root');
  });
}
