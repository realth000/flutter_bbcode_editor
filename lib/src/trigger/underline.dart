import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/trigger/base.dart';

extension EditorUnderline on BBCodeEditorState {
  /// Check the current editor state and selection is in underline state.
  ///
  /// Useful when changing state.
  bool isUnderline() =>
      checkStateSelectionAttrValue<bool>(
          editorState, decorationNameUnderline) ??
      false;

  /// Insert underline style into the editor.
  ///
  /// * When currently have some selected text, add underline tag around those text.
  /// * When no text is selected, add underline tag in the editor and move cursor
  ///   inside the tag.
  Future<void> triggerUnderline() async =>
      toggleStateSelectionAttr(editorState, decorationNameUnderline);
}

String parseUnderline(Map<String, dynamic> attr, String text) {
  if (attr.containsKey(decorationNameUnderline) &&
      attr[decorationNameUnderline] is bool &&
      attr[decorationNameUnderline] as bool) {
    return '[u]$text[/u]';
  }
  return text;
}
