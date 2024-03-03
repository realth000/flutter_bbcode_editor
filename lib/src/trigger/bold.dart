import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/trigger/base.dart';

extension EditorBold on BBCodeEditorState {
  /// Check the current editor state and selection is in bold state.
  ///
  /// Useful when changing state.
  bool isBold() {
    return checkStateSelectionAttr(editorState, decorationNameBold);
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
