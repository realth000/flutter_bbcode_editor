import 'package:flutter/widgets.dart';

import 'app_state.dart';

class BBCodeStateManager extends InheritedWidget {
  const BBCodeStateManager({
    super.key,
    required super.child,
    required BBCodeEditorState state,
  }) : _appState = state;

  static BBCodeStateManager of(BuildContext context) {
    final BBCodeStateManager? result =
        context.dependOnInheritedWidgetOfExactType<BBCodeStateManager>();
    assert(result != null, 'No AppStateManager found in context');
    return result!;
  }

  final BBCodeEditorState _appState;

  BBCodeEditorState get bbcodeState => _appState;

  @override
  bool updateShouldNotify(BBCodeStateManager oldWidget) {
    return bbcodeState != oldWidget.bbcodeState;
  }
}
