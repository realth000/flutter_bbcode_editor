import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/trigger/base.dart';

extension EditorFontSize on BBCodeEditorState {
  /// Get current font size value.
  double? getFontSize() =>
      checkStateSelectionAttrValue<double>(editorState, decorationFontSize);

  /// Set the font size value.
  Future<void> triggerFontSize(double? fontSize) async =>
      editorState?.formatDelta(
        editorState!.selection,
        {decorationFontSize: fontSize},
      );
}
