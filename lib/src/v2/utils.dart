import 'package:collection/collection.dart';
import 'package:flutter_bbcode_editor/src/v2/constants.dart';

/// Color utility.
class ColorUtils {
  static final _colorRe = RegExp(r'^(#)?[0-9a-fA-F]{1,8}$');

  /// Check [color] is valid color or not.
  ///
  /// Return true if is valid color.
  static bool isColor(String color) {
    if (BBCodeEditorColor.values
            .firstWhereOrNull((e) => e.namedColor == color) !=
        null) {
      return true;
    }

    if (_colorRe.hasMatch(color)) {
      return true;
    }

    return false;
  }
}
