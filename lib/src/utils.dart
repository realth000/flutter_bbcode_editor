import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:dart_bbcode_web_colors/dart_bbcode_web_colors.dart';
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
    // Try use named color first.
    int? colorValue;

    if (color.startsWith('#')) {
      colorValue = int.tryParse(color.substring(1), radix: 16);
    } else {
      colorValue = int.tryParse(color, radix: 16);
    }

    final WebColors webColor;
    if (colorValue != null) {
      // WebColors all have alpha value, append the same value if not have it.
      if (colorValue < 0xFF000000) {
        colorValue += 0xFF000000;
      }
      webColor = WebColors.values.firstWhereOrNull((e) => e.colorValue == colorValue) ?? WebColors.fromString(color);
    } else {
      webColor = WebColors.fromString(color);
    }

    if (webColor.isValid) {
      return '${webColor.name[0].toUpperCase()}${webColor.name.substring(1)}';
    }

    // For some shorthand format, keep it's original style.
    if (color.length < 2 || (color.length == 4 && color.startsWith('#'))) {
      return color;
    }

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
      final r = ((sr * sa + 0 * (1 - sa)) * 255).toInt().toRadixString(16).padLeft(2, '0');
      final g = ((sg * sa + 0 * (1 - sa)) * 255).toInt().toRadixString(16).padLeft(2, '0');
      final b = ((sb * sa + 0 * (1 - sa)) * 255).toInt().toRadixString(16).padLeft(2, '0');
      return '#$r$g$b';
    } else {
      return 'rgb(${(bbcodeColor.r * 255).toInt()}, '
          '${(bbcodeColor.g * 255).toInt()}, '
          '${(bbcodeColor.b * 255).toInt()})';
    }
  }
}
