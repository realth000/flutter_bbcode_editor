import 'dart:ui';

import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/trigger/base.dart';

extension EditorForegroundColor on BBCodeEditorState {
  /// Get the text color on current selection if it has.
  ///
  /// Only return a not-null value when all nodes in selection have the same
  /// text color.
  String? getForegroundColor() => checkStateSelectionAttrValue<String>(
        editorState,
        decorationForegroundColor,
      );

  /// Trigger text color on current state.
  ///
  /// Originally from "appflowy-editor/lib/src/editor/toolbar/utils/format_color.dart"
  Future<void> triggerForegroundColor(String? color) async =>
      toggleStateSelectionAttrValue(
        editorState,
        decorationForegroundColor,
        color,
        lastUsedSelection: lastUsedSelection,
      );
}

String parseForegroundColor(Map<String, dynamic> attr, String text) {
  final fontColor = attr[decorationForegroundColor];
  if (fontColor == null || fontColor is! String) {
    return text;
  }

  final colorValue = int.tryParse(fontColor.substring(2), radix: 16);
  if (colorValue == null) {
    return text;
  }
  final color = Color(colorValue);

  return '[color=rgb(${color.red}, ${color.green}, ${color.blue})]$text[/color]';
}
