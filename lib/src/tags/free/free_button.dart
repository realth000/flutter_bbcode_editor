import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/tags/free/free_embed.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Free button in toolbar.
class BBCodeEditorToolbarFreeButton extends StatelessWidget {
  /// Constructor.
  const BBCodeEditorToolbarFreeButton({required this.controller, this.afterPressed, super.key});

  /// Injected editor controller.
  final BBCodeEditorController controller;

  /// Callback after button pressed.
  final void Function()? afterPressed;

  @override
  Widget build(BuildContext context) {
    return QuillToolbarIconButton(
      icon: const Icon(Icons.money_off_outlined),
      tooltip: context.bbcodeL10n.free,
      iconTheme: const QuillIconTheme(),
      isSelected: false,
      onPressed: () async {
        controller
          ..skipRequestKeyboard = false
          ..insertEmbeddable(BBCodeFreeHeaderEmbed(const BBCodeFreeHeaderInfo()))
          ..insertEmbeddable(BBCodeFreeTailEmbed(const BBCodeFreeTailInfo()))
          ..moveCursorToPosition(controller.selection.baseOffset - 1);
      },
      afterPressed: afterPressed,
    );
  }
}
