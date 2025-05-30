import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/tags/emoji/emoji_embed.dart';
import 'package:flutter_bbcode_editor/src/types.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Emoji button in editor toolbar.
class BBCodeEditorToolbarEmojiButton extends StatelessWidget {
  /// Constructor.
  const BBCodeEditorToolbarEmojiButton({
    required this.controller,
    required this.emojiPicker,
    this.afterPressed,
    super.key,
  });

  /// Injected emoji picker.
  ///
  /// Called when user pressed emoji toolbar button, returns.
  final BBCodeEmojiPicker emojiPicker;

  /// Injected editor controller.
  final BBCodeEditorController controller;

  /// Callback after button pressed.
  final void Function()? afterPressed;

  @override
  Widget build(BuildContext context) {
    return QuillToolbarIconButton(
      icon: const Icon(Icons.emoji_emotions),
      tooltip: context.bbcodeL10n.emojiInsertEmoji,
      isSelected: false,
      iconTheme: const QuillIconTheme(),
      onPressed: () async {
        final code = await emojiPicker(context);
        if (code != null) {
          // FIXME: Waiting for upstream fix. check func definition for details.
          controller.insertEmbeddable(BBCodeEmojiEmbed.raw(code));
        }
      },
      afterPressed: afterPressed,
    );
  }
}
