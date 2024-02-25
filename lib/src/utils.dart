import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Extension to modify color.
extension ModifyColor on Color {
  /// Return a darken color.
  ///
  /// This function is from the flex_color_scheme package.
  Color darken([int amount = 10]) {
    if (amount <= 0) return this;
    if (amount > 100) return Colors.black;
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness(math.min(1, math.max(0, hsl.lightness - amount / 100)))
        .toColor();
  }

  /// Return a brighter color.
  ///
  /// This function is from the flex_color_scheme package.
  Color brighten([int amount = 10]) {
    if (amount <= 0) return this;
    if (amount > 100) return Colors.white;
    final color = Color.fromARGB(
      alpha,
      math.max(0, math.min(255, red - (255 * -(amount / 100)).round())),
      math.max(0, math.min(255, green - (255 * -(amount / 100)).round())),
      math.max(0, math.min(255, blue - (255 * -(amount / 100)).round())),
    );
    return color;
  }
}
