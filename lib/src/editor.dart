import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/convert/to_bbcode.dart';
import 'package:flutter_bbcode_editor/src/editor_configuration.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/l10n/l10n_widget.dart';
import 'package:flutter_bbcode_editor/src/portation_button.dart';
import 'package:flutter_bbcode_editor/src/tags/emoji/emoji_builder.dart';
import 'package:flutter_bbcode_editor/src/tags/emoji/emoji_button.dart';
import 'package:flutter_bbcode_editor/src/tags/image/image_builder.dart';
import 'package:flutter_bbcode_editor/src/tags/image/image_button.dart';
import 'package:flutter_bbcode_editor/src/tags/spoiler/spoiler_builder.dart';
import 'package:flutter_bbcode_editor/src/tags/spoiler/spoiler_button.dart';
import 'package:flutter_bbcode_editor/src/tags/user_mention/user_mention_builder.dart';
import 'package:flutter_bbcode_editor/src/tags/user_mention/user_mention_button.dart';
import 'package:flutter_bbcode_editor/src/types.dart';
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
    this.imagePicker,
    this.userMentionHandler,
    this.scrollController,
    this.focusNode,
    this.urlLauncher,
    this.autoFocus = false,
    this.initialText,
    this.imageConstraints,
    this.usernamePicker,
    this.moveCursorToEndOnInitState = true,
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

  /// Callback when need to pick an image.
  final BBCodeImagePicker? imagePicker;

  /// Callback when user tap on text with user mention attribute.
  final BBCodeUserMentionHandler? userMentionHandler;

  /// Callback when user intend to launch an url.
  final void Function(String)? urlLauncher;

  /// Callback when need to pick username.
  final BBCodeUsernamePicker? usernamePicker;

  /// Automatically requires focus.
  final bool autoFocus;

  /// Optional initial text.
  final String? initialText;

  /// Enable this flag if intend to move the cursor to the end of document once
  /// the [initialText] applied to the editor.
  final bool moveCursorToEndOnInitState;

  /// Optional layout constraints when rendering image.
  final BoxConstraints? imageConstraints;

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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controllerV2.setDocumentFromRawText(widget.initialText!);
        if (widget.moveCursorToEndOnInitState) {
          _controllerV2.moveCursorToEnd();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BBCodeLocalizationsWidget(
      child: FlutterQuillLocalizationsWidget(
        child: QuillEditor.basic(
          controller: _controllerV2._quillController,
          scrollController: widget.scrollController,
          focusNode: widget.focusNode,
          configurations: QuillEditorConfigurations(
            autoFocus: widget.autoFocus,
            embedBuilders: [
              BBCodeImageEmbedBuilder(
                widget.imageProvider,
                widget.imagePicker,
                constraints: widget.imageConstraints,
              ),
              BBCodeEmojiEmbedBuilder(emojiProvider: widget.emojiProvider),
              BBCodeUserMentionEmbedBuilder(
                usernamePicker: widget.usernamePicker,
              ),
              BBCodeSpoilerEmbedBuilder(),
            ],
            onLaunchUrl: widget.urlLauncher,
          ),
        ),
      ),
    );
  }
}
