import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/l10n/l10n_widget.dart';
import 'package:flutter_bbcode_editor/src/v2/constants.dart';
import 'package:flutter_bbcode_editor/src/v2/context.dart';
import 'package:flutter_bbcode_editor/src/v2/convert/to_bbcode.dart';
import 'package:flutter_bbcode_editor/src/v2/editor_configuration.dart';
import 'package:flutter_bbcode_editor/src/v2/editor_value.dart';
import 'package:flutter_bbcode_editor/src/v2/extensions/to_bbcode.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/align.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/background_color.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/bold.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/code_block.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/color.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/emoji/emoji_builder.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/emoji/emoji_button.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/font_family.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/font_size.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/image/image_builder.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/image/image_button.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/italic.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/quote_block.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/script.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/strikethrough.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/underline.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/url.dart';
import 'package:flutter_quill/flutter_quill.dart';
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
    this.focusNode,
    this.onLaunchUrl,
    this.autoFocus = false,
    super.key,
  }) : _controller = controller;

  final BBCodeEditorController _controller;

  /// Editor focus node.
  final FocusNode? focusNode;

  // TODO: Make optional.
  /// Callback when need to build an image according to the emoji bbcode code.
  ///
  final BBCodeEmojiProvider emojiProvider;

  /// Callback when user intend to launch an url.
  final void Function(String)? onLaunchUrl;

  /// Automatically requires focus.
  final bool autoFocus;

  @override
  State<BBCodeEditor> createState() => _BBCodeEditorState();
}

class _BBCodeEditorState extends State<BBCodeEditor> {
  late final BBCodeEditorController _controllerV2;

  @override
  void initState() {
    super.initState();
    _controllerV2 = widget._controller;
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
              focusNode: widget.focusNode,
              configurations: QuillEditorConfigurations(
                autoFocus: widget.autoFocus,
                controller: _controllerV2._quillController,
                embedBuilders: [
                  BBCodeImageEmbedBuilder(),
                  BBCodeEmojiEmbedBuilder(emojiProvider: widget.emojiProvider),
                ],
                onLaunchUrl: widget.onLaunchUrl,
              ),
            ),
          ),
        );
      },
    );
  }
}
