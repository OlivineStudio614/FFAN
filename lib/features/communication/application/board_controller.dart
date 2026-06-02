import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'analytics_service.dart';
import 'providers.dart';

/// Immutable navigation state: a stack of folder ids. The bottom is always
/// the root folder.
@immutable
class BoardState {
  const BoardState(this.stack);
  const BoardState.initial() : stack = const ['root'];

  final List<String> stack;

  String get currentFolderId => stack.last;
  bool get canGoBack => stack.length > 1;
}

class BoardController extends Notifier<BoardState> {
  @override
  BoardState build() => const BoardState.initial();

  AnalyticsService get _analytics => ref.read(analyticsServiceProvider);

  void openFolder(String folderId) {
    state = BoardState([...state.stack, folderId]);
    _analytics.logFolderOpened(folderId);
  }

  void goBack() {
    if (!state.canGoBack) return;
    state = BoardState(state.stack.sublist(0, state.stack.length - 1));
  }

  void goHome() => state = const BoardState.initial();
}

final boardControllerProvider =
    NotifierProvider<BoardController, BoardState>(BoardController.new);
