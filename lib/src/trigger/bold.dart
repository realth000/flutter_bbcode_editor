import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/trigger/base.dart';

extension EditorBold on BBCodeEditorState {
  /// Check the current editor state and selection is in bold state.
  ///
  /// Useful when changing state.
  bool isBold() {
    return checkStateSelectionAttrValue<bool>(
          editorState,
          decorationNameBold,
        ) ??
        false;
  }

  /// Insert bold style into the editor.
  ///
  /// * When currently have some selected text, add bold tag around those text.
  /// * When no text is selected, add bold tag in the editor and move cursor
  ///   inside the tag.
  Future<void> triggerBold() async {
    await toggleStateSelectionAttr(editorState, decorationNameBold);
  }
}

String parseBold(Map<String, dynamic> attr, String text) {
  if (attr.containsKey(decorationNameBold) &&
      attr[decorationNameBold] is bool &&
      attr[decorationNameBold] as bool) {
    return '[b]$text[/b]';
  }
  return text;
}
