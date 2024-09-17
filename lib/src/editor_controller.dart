part of 'editor.dart';

/// V2 editor controller.
final class BBCodeEditorController {
  /// Constructor.
  BBCodeEditorController({
    this.focusNode,
  }) {
    _quillController = QuillController.basic(editorFocusNode: focusNode);
  }

  /// Optional focus node to manage focus.
  final FocusNode? focusNode;

  /// Underlying quill editor controller.
  late final QuillController _quillController;

  /// Convert current document to json format
  String toJson() => jsonEncode(_quillController.document.toDelta().toJson());

  /// Set the document from json data.
  void setDocumentFromJson(List<dynamic> json) =>
      _quillController.document = Document.fromJson(json);

  /// Set the document from raw text without format.
  void setDocumentFromRawText(String text) {
    final String fixedText;
    if (text.isNotEmpty && text.endsWith('\n')) {
      fixedText = text;
    } else {
      fixedText = '$text\n';
    }
    _quillController.document =
        Document.fromDelta(Delta.fromOperations([Operation.insert(fixedText)]));
  }

  /// Check if editor has empty content.
  bool get isEmpty {
    final deltaList = _quillController.document.toDelta();
    if (deltaList.isEmpty) {
      // Impossible
      return true;
    }
    if (deltaList.length > 1) {
      return false;
    }
    final firstDelta = deltaList[0].data;
    if (firstDelta is String) {
      return firstDelta == '\n';
    } else {
      return false;
    }
  }

  /// Check if editor has empty content.
  bool get isNotEmpty => !isEmpty;

  /// Add [callback] on each editor state change.
  void addListener(VoidCallback callback) =>
      _quillController.addListener(callback);

  /// Remove [callback].
  void removeListener(VoidCallback callback) =>
      _quillController.removeListener(callback);

  /// Clear all content in editor.
  void clear() => _quillController.clear();

  /// Convert current document to bbcode.
  String toBBCode() {
    final converter = DeltaToBBCode();
    final ret = converter.convert(_quillController.document.toDelta());
    return ret;
  }

  /// Convert current document to quill delta.
  String toQuillDelta() =>
      jsonEncode(_quillController.document.toDelta().toJson());

  /// Insert [text] into current cursor position and format with [attr].
  void insertFormattedText(String text, Attribute<dynamic> attr) {
    _quillController
      ..replaceText(_quillController.index, _quillController.length, text, null)
      ..formatText(_quillController.index, text.length, attr)
      ..moveCursorToPosition(_quillController.index + text.length);
  }

  /// Insert formatted embed block [data] into editor.
  void insertEmbedBlock(String embedType, String data) {
    _quillController
      ..replaceText(
        _quillController.index,
        _quillController.length,
        BlockEmbed.custom(CustomBlockEmbed(embedType, data)),
        null,
      )
      ..editorFocusNode?.requestFocus()
      ..moveCursorToPosition(_quillController.index + 1);
  }

  /// Dispose the controller.
  void dispose() {
    _quillController.dispose();
  }
}
