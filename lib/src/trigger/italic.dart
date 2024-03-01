import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/trigger/base.dart';

extension EditorItalic on BBCodeEditorState {
  /// Check the current editor state and selection is in italic state.
  ///
  /// Useful when changing state.
  bool isItalic() {
    if (editorState == null) {
      return false;
    }
    return checkStateSelectionAttr(editorState!, decorationNameItalic);
  }

  /// Insert italic style into the editor.
  ///
  /// * When currently have some selected text, add italic tag around those text.
  /// * When no text is selected, add italic tag in the editor and move cursor
  ///   inside the tag.
  Future<void> triggerItalic() async {
    await toggleStateSelectionAttr(editorState, decorationNameItalic);
  }
}
