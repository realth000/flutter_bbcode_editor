import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/trigger/base.dart';

extension EditorBackgroundColor on BBCodeEditorState {
  /// Get the background color on current selection if it has.
  ///
  /// Only return a not-null value when all nodes in selection have the same
  /// background color.
  String? getBackgroundColor() => checkStateSelectionAttrValue<String>(
        editorState,
        decorationBackgroundColor,
      );

  /// Trigger background color on current state.
  ///
  /// Originally from "appflowy-editor/lib/src/editor/toolbar/utils/format_color.dart"
  Future<void> triggerBackgroundColor(String? color) async =>
      toggleStateSelectionAttrValue(
        editorState,
        decorationBackgroundColor,
        color,
        lastUsedSelection: lastUsedSelection,
      );
}
