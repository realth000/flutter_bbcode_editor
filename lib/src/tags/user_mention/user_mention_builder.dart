import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/l10n/l10n_widget.dart';
import 'package:flutter_bbcode_editor/src/tags/user_mention/user_mention_button.dart';
import 'package:flutter_bbcode_editor/src/tags/user_mention/user_mention_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/translations.dart';

/// Embed builder for user mention type.
///
/// Build a area of text, contains "@" following user's name to mention, with
/// rounded background color.
final class BBCodeUserMentionEmbedBuilder extends EmbedBuilder {
  /// Constructor.
  BBCodeUserMentionEmbedBuilder({this.usernamePicker});

  final BBCodeUsernamePicker? usernamePicker;

  @override
  String get key => UserMentionAttributeKeys.key;

  @override
  bool get expanded => false;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final initialUsername = node.value.data as String;

    return GestureDetector(
      onTap: () async {
        String? username;
        if (usernamePicker != null) {
          username = await usernamePicker!.call(
            context,
            username: initialUsername,
          );
        } else {
          username = await showDialog<String>(
            context: context,
            builder: (_) => BBCodeLocalizationsWidget(
              child: FlutterQuillLocalizationsWidget(
                child: PickUserMentionDialog(username: initialUsername),
              ),
            ),
          );
        }

        if (username == null) {
          return;
        }

        final offset = getEmbedNode(
          controller,
          controller.selection.start,
        ).offset;
        controller
          ..replaceText(
            offset,
            1,
            BlockEmbed.custom(
              CustomBlockEmbed(
                UserMentionAttributeKeys.key,
                username,
              ),
            ),
            TextSelection.collapsed(offset: offset),
          )
          ..editorFocusNode?.requestFocus()
          ..moveCursorToPosition(offset + 1);
      },
      child: Text(
        '@$initialUsername',
        style: TextStyle(
          // // refer: https://stackoverflow.com/a/70293635
          // background: Paint()
          //   ..color = Theme.of(context).colorScheme.onPrimary
          //   ..strokeWidth = 10
          //   ..strokeJoin = StrokeJoin.round
          //   ..strokeCap = StrokeCap.round
          //   ..style = PaintingStyle.stroke,
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
        ),
      ),
    );
  }
}
