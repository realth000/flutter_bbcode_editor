import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/base.dart';

/// Popup menu widget provides completion results.
class CompletionPopupMenu extends EditorPopupMenu {
  @override
  Alignment get alignment => Alignment.topLeft;

  @override
  void dismiss() {
    // TODO: implement dismiss
  }

  @override
  (double?, double?, double?, double?) getPosition() {
    double? left;
    double? top;
    double? right;
    double? bottom;
    switch (alignment) {
      case Alignment.topLeft:
        left = offset.dx;
        top = offset.dy;
      case Alignment.bottomLeft:
        left = offset.dx;
        bottom = offset.dy;
      case Alignment.topRight:
        right = offset.dx;
        top = offset.dy;
      case Alignment.bottomRight:
        right = offset.dx;
        bottom = offset.dy;
    }
    return (left, top, right, bottom);
  }

  @override
  Offset get offset => Offset.zero;

  @override
  void show() {
    // TODO: implement show
  }
}

// TODO: Implement
final completionCommand = CharacterShortcutEvent(
  key: 'show the completion menu',
  character: '[',
  handler: (editorState) async => showCompletionMenu(editorState),
);

Future<bool> showCompletionMenu(
  EditorState editorState,
) async {
  if (PlatformExtension.isMobile) {
    return false;
  }
  return true;
}

// final boldCommand = CharacterShortcutEvent(
//   key: 'Convert [b] into bold',
// );
