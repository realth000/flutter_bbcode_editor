import 'package:flutter/cupertino.dart';
import 'package:flutter_bbcode_editor/src/v2/editor_controller.dart';
import 'package:flutter_quill/flutter_quill.dart';

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
        controller: _controllerV2.quillController,
      ),
    );
  }
}
