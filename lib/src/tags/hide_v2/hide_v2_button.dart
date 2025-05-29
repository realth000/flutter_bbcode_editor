import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/tags/hide_v2/hide_v2_embed.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Hide v2 button in toolbar.
class BBCodeEditorToolbarHideV2Button extends StatelessWidget {
  /// Constructor.
  const BBCodeEditorToolbarHideV2Button({required this.controller, this.afterPressed, super.key});

  /// Injected editor controller.
  final BBCodeEditorController controller;

  /// Callback after button pressed.
  final void Function()? afterPressed;

  @override
  Widget build(BuildContext context) {
    return QuillToolbarIconButton(
      icon: const Icon(Icons.visibility_off_outlined),
      tooltip: context.bbcodeL10n.hideV2,
      iconTheme: const QuillIconTheme(),
      isSelected: false,
      onPressed: () async {
        controller
          ..skipRequestKeyboard = false
          ..insertEmbeddable(BBCodeHideV2HeaderEmbed(const BBCodeHideV2HeaderInfo(0)))
          ..insertEmbeddable(BBCodeHideV2TailEmbed())
          ..moveCursorToPosition(controller.selection.baseOffset - 1);
      },
      afterPressed: afterPressed,
    );
  }
}
