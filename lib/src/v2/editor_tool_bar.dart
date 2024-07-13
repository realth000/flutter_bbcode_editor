import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/v2/editor_controller.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Toolbar of the editor.
class BBCodeEditorToolBar extends StatefulWidget {
  /// Constructor.
  const BBCodeEditorToolBar({
    required BBCodeEditorController controller,
    super.key,
  }) : _controller = controller;

  final BBCodeEditorController _controller;

  @override
  State<BBCodeEditorToolBar> createState() => _BBCodeEditorToolBarState();
}

class _BBCodeEditorToolBarState extends State<BBCodeEditorToolBar> {
  late final BBCodeEditorController controller;

  @override
  void initState() {
    super.initState();
    controller = widget._controller;
  }

  @override
  Widget build(BuildContext context) {
    return QuillToolbar.simple(
      configurations: QuillSimpleToolbarConfigurations(
        controller: controller.quillController,
        // Below are all formats implemented in quill but not supported in TSDM.
        // These formats are disabled on default.
        showInlineCode: false,
        // Use font size instead.
        showHeaderStyle: false,
        showListCheck: false,
        showIndent: false,
        showDirection: true,
        showSearchButton: false,
        showSubscript: false,
      ),
    );
  }
}
