import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/trigger/base.dart';

extension EditorItalic on BBCodeEditorState {
  /// Check the current editor state and selection is in italic state.
  ///
  /// Useful when changing state.
  bool isItalic() =>
      checkStateSelectionAttrValue<bool>(editorState, decorationNameItalic) ??
      false;

  /// Insert italic style into the editor.
  ///
  /// * When currently have some selected text, add italic tag around those text.
  /// * When no text is selected, add italic tag in the editor and move cursor
  ///   inside the tag.
  Future<void> triggerItalic() async =>
      toggleStateSelectionAttr(editorState, decorationNameItalic);
}

String parseItalic(Map<String, dynamic> attr, String text) {
  if (attr.containsKey(decorationNameItalic) &&
      attr[decorationNameItalic] is bool &&
      attr[decorationNameItalic] as bool) {
    return '[i]$text[/i]';
  }
  return text;
}
