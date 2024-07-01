import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/v2/editor_value.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// V2 editor controller.
final class BBCodeEditorController extends ValueNotifier<BBCodeEditorValue> {
  /// Constructor.
  BBCodeEditorController() : super(BBCodeEditorValue());

  /// Underlying quill editor controller.
  final QuillController quillController = QuillController.basic();

  @override
  void dispose() {
    quillController.dispose();
    super.dispose();
  }
}
