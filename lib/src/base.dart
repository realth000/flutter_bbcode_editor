import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Basic definition of any popup menus in editor.
///
/// These menus are triggered by pressing keys.
///
/// Copied from: appflowy-editor/lib/src/editor/selection_menu/selection_menu_service.dart
abstract class EditorPopupMenu {
  /// Widget position offset.
  Offset get offset;

  /// Widget alignment.
  Alignment get alignment;

  /// Show the widget.
  void show();

  /// Close the widget.
  void dismiss();

  /// Get the widget position.
  (double? left, double? top, double? right, double? bottom) getPosition();
}
