import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/trigger/base.dart';

extension EditorStrikethrough on BBCodeEditorState {
  /// Check the current editor state and selection is in strikethrough state.
  ///
  /// Useful when changing state.
  bool isStrikethrough() =>
      checkStateSelectionAttrValue<bool>(
          editorState, decorationNameStrikethrough) ??
      false;

  /// Insert strikethrough style into the editor.
  ///
  /// * When currently have some selected text, add strikethrough tag around those text.
  /// * When no text is selected, add strikethrough tag in the editor and move cursor
  ///   inside the tag.
  Future<void> triggerStrikethrough() async =>
      toggleStateSelectionAttr(editorState, decorationNameStrikethrough);
}
