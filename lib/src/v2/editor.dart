import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/v2/constants.dart';
import 'package:flutter_bbcode_editor/src/v2/context.dart';
import 'package:flutter_bbcode_editor/src/v2/editor_configuration.dart';
import 'package:flutter_bbcode_editor/src/v2/editor_value.dart';
import 'package:flutter_bbcode_editor/src/v2/extensions/to_bbcode.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/align.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/background_color.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/bold.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/code_block.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/color.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/font_family.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/font_size.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/italic.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/quote_block.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/script.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/strikethrough.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/underline.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/url.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

part 'editor_controller.dart';
part 'editor_tool_bar.dart';

/// Quill based bbcode editor.
class BBCodeEditor extends StatefulWidget {
  /// Constructor.
  const BBCodeEditor({
    required BBCodeEditorController controller,
    this.focusNode,
    super.key,
  }) : _controller = controller;

  final BBCodeEditorController _controller;

  /// Editor focus node.
  final FocusNode? focusNode;

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
    return QuillEditor.basic(
      focusNode: widget.focusNode,
      configurations: QuillEditorConfigurations(
        controller: _controllerV2._quillController,
        embedBuilders: kIsWeb
            ? FlutterQuillEmbeds.editorWebBuilders()
            : FlutterQuillEmbeds.editorBuilders(),
      ),
    );
  }
}
