import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/convert/to_bbcode.dart';
import 'package:flutter_bbcode_editor/src/editor_configuration.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/l10n/l10n_widget.dart';
import 'package:flutter_bbcode_editor/src/tags/emoji/emoji_builder.dart';
import 'package:flutter_bbcode_editor/src/tags/emoji/emoji_button.dart';
import 'package:flutter_bbcode_editor/src/tags/image/image_builder.dart';
import 'package:flutter_bbcode_editor/src/tags/image/image_button.dart';
import 'package:flutter_bbcode_editor/src/tags/user_mention/user_mention_button.dart';
import 'package:flutter_bbcode_editor/src/tags/user_mention/user_mention_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_quill/translations.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

part 'editor_controller.dart';
part 'editor_tool_bar.dart';

/// Quill based bbcode editor.
class BBCodeEditor extends StatefulWidget {
  /// Constructor.
  const BBCodeEditor({
    required BBCodeEditorController controller,
    // TODO: Make optional.
    required this.emojiProvider,
    this.imageProvider,
    this.userMentionHandler,
    this.scrollController,
    this.focusNode,
    this.urlLauncher,
    this.autoFocus = false,
    this.initialText,
    super.key,
  }) : _controller = controller;

  final BBCodeEditorController _controller;

  /// Optional scroll controller of editor.
  final ScrollController? scrollController;

  /// Editor focus node.
  final FocusNode? focusNode;

  // TODO: Make optional.
  /// Callback when need to build an image according to the emoji bbcode code.
  ///
  final BBCodeEmojiProvider emojiProvider;

  /// Callback when need to build an image from given url.
  final BBCodeImageProvider? imageProvider;

  /// Callback when user tap on text with user mention attribute.
  final BBCodeUserMentionHandler? userMentionHandler;

  /// Callback when user intend to launch an url.
  final void Function(String)? urlLauncher;

  /// Automatically requires focus.
  final bool autoFocus;

  /// Optional initial text.
  final String? initialText;

  @override
  State<BBCodeEditor> createState() => _BBCodeEditorState();
}

class _BBCodeEditorState extends State<BBCodeEditor> {
  late final BBCodeEditorController _controllerV2;

  @override
  void initState() {
    super.initState();
    _controllerV2 = widget._controller;
    if (widget.initialText != null) {
      _controllerV2.setDocumentFromRawText(widget.initialText!);
    }
  }

  @override
  Widget build(BuildContext context) {
    // FutureBuilder as a workaround for
    // https://github.com/singerdmx/flutter-quill/issues/2045
    return FutureBuilder(
      future: Future.value(''),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        return BBCodeLocalizationsWidget(
          child: FlutterQuillLocalizationsWidget(
            child: QuillEditor.basic(
              scrollController: widget.scrollController,
              focusNode: widget.focusNode,
              configurations: QuillEditorConfigurations(
                autoFocus: widget.autoFocus,
                controller: _controllerV2._quillController,
                embedBuilders: [
                  BBCodeImageEmbedBuilder(widget.imageProvider),
                  BBCodeEmojiEmbedBuilder(emojiProvider: widget.emojiProvider),
                ],
                onLaunchUrl: widget.urlLauncher,
                customRecognizerBuilder: (attribute, node) {
                  // User mention
                  if (attribute.key == UserMentionAttributeKeys.key) {
                    return TapGestureRecognizer()
                      ..onTap = () async => widget.userMentionHandler
                          ?.call(attribute.value as String);
                  }
                  return null;
                },
                customStyleBuilder: (attribute) {
                  // User mention
                  if (attribute.key == UserMentionAttributeKeys.key) {
                    return const TextStyle(
                      decoration: TextDecoration.underline,
                    );
                  }
                  return const TextStyle();
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
