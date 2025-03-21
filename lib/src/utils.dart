import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter_bbcode_editor/src/constants.dart';

/// Color utility.
class ColorUtils {
  static final _colorRe = RegExp(r'^(#)?[0-9a-fA-F]{1,8}$');

  /// Check [color] is valid color or not.
  ///
  /// Return true if is valid color.
  static bool isColor(String color) {
    if (BBCodeEditorColor.values.firstWhereOrNull((e) => e.namedColor == color) != null) {
      return true;
    }

    if (_colorRe.hasMatch(color)) {
      return true;
    }

    return false;
  }

  /// Convert into bbcode recognized color.
  static String toBBCodeColor(String color, {bool useHex = true}) {
    // For some shorthand format, keep it's original style.
    if (color.length < 2 || (color.length == 4 && color.startsWith('#'))) {
      return color;
    }

    final colorValue = int.tryParse(color.substring(2), radix: 16);
    if (colorValue == null) {
      return color;
    }
    final bbcodeColor = Color(colorValue);

    // Remove alpha.

    if (useHex) {
      // refer: https://stackoverflow.com/a/2049362
      final sr = bbcodeColor.r;
      final sg = bbcodeColor.g;
      final sb = bbcodeColor.b;
      final sa = bbcodeColor.a;
      final r = ((sr * sa + 0 * (1 - sa)) * 255).toInt().toRadixString(16);
      final g = ((sg * sa + 0 * (1 - sa)) * 255).toInt().toRadixString(16);
      final b = ((sb * sa + 0 * (1 - sa)) * 255).toInt().toRadixString(16);
      return '#$r$g$b';
    } else {
      return 'rgb(${(bbcodeColor.r * 255).toInt()}, '
          '${(bbcodeColor.g * 255).toInt()}, '
          '${(bbcodeColor.b * 255).toInt()})';
    }
  }
}
