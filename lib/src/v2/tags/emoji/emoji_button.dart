import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/v2/constants.dart';
import 'package:flutter_bbcode_editor/src/v2/editor.dart';
import 'package:flutter_bbcode_editor/src/v2/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/emoji/emoji_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// External emoji picker function.
///
/// Calling from emoji site.
typedef BBCodeEmojiPicker = FutureOr<String?> Function(BuildContext context);

/// Emoji button in editor toolbar.
class BBCodeEditorToolbarEmojiButton extends StatelessWidget {
  /// Constructor.
  const BBCodeEditorToolbarEmojiButton({
    required this.controller,
    required this.emojiPicker,
    super.key,
  });

  /// Injected emoji picker.
  ///
  /// Called when user pressed emoji toolbar button, returns.
  final BBCodeEmojiPicker emojiPicker;

  /// Injected editor controller.
  final BBCodeEditorController controller;

  @override
  Widget build(BuildContext context) {
    return QuillToolbarIconButton(
      icon: const Icon(Icons.emoji_emotions),
      tooltip: context.bbcodeL10n.emojiInsertEmoji,
      isSelected: false,
      iconTheme: context.quillToolbarBaseButtonOptions?.iconTheme,
      onPressed: () async {
        final code = await emojiPicker(context);
        if (code != null) {
          controller.insertEmbedBlock(
            BBCodeEmbedTypes.emoji,
            jsonEncode(BBCodeEmojiInfo(code).toJson()),
          );
        }
      },
    );
  }
}
