import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/trigger/base.dart';

extension EditorFontSize on BBCodeEditorState {
  /// Get current font size value.
  double? getFontSize() =>
      checkStateSelectionAttrValue<double>(editorState, decorationFontSize);

  /// Set the font size value.
  Future<void> triggerFontSize(double? fontSize) async =>
      toggleStateSelectionAttrValue(editorState, decorationFontSize, fontSize);
}

String parseFontSize(Map<String, dynamic> attr, String text) {
  final fontSize = attr[decorationFontSize];
  if (fontSize == null || fontSize is! double) {
    return text;
  }

  for (final e in defaultLevelToFontSizeMap.entries) {
    if (e.value == fontSize) {
      return '[size=${e.key}]$text[/size]';
    }
  }
  return text;
}
