part of 'editor.dart';

/// Alias type.
typedef BBCodeEditorController = QuillController;

/// Build a [BBCodeEditorController].
BBCodeEditorController buildBBCodeEditorController({
  FocusNode? focusNode,
  bool readOnly = false,
  String? initialText,
}) {
  return QuillController(
    editorFocusNode: focusNode,
    document: initialText != null && initialText.isNotEmpty
        ? Document.fromDelta(Delta()..insert(initialText))
        : Document(),
    selection: const TextSelection.collapsed(offset: 0),
    readOnly: readOnly,
  );
}

/// BBCode functionality extension on [QuillController].
extension BBCodeExt on BBCodeEditorController {
  /// Convert current document to json format
  String toJson() => jsonEncode(document.toDelta().toJson());

  /// Set the document from json data.
  void setDocumentFromJson(List<dynamic> json) =>
      document = Document.fromJson(json);

  /// Set the document from quill delta.
  void setDocumentFromDelta(Delta delta) =>
      document = Document.fromDelta(delta);

  /// Set the document from raw text without format.
  void setDocumentFromRawText(String text) {
    final String fixedText;
    if (text.endsWith('\n')) {
      fixedText = text;
    } else {
      fixedText = '$text\n';
    }
    document =
        Document.fromDelta(Delta.fromOperations([Operation.insert(fixedText)]));
  }

  /// Check if editor has empty content.
  bool get isEmpty {
    final deltaList = document.toDelta();
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

  /// Convert current document to bbcode.
  String toBBCode() {
    final converter = DeltaToBBCode();
    final ret = converter.convert(document.toDelta());
    return ret;
  }

  /// Convert current document to quill delta.
  String toQuillDelta() => jsonEncode(document.toDelta().toJson());

  /// Insert [text] into current cursor position and format with [attr].
  void insertFormattedText(String text, Attribute<dynamic> attr) {
    this
      ..replaceText(index, length, text, null)
      ..formatText(index, text.length, attr)
      ..moveCursorToPosition(index + text.length);
  }

  /// Insert formatted embed block [embed] into editor.
  void insertEmbedBlock(CustomBlockEmbed embed) {
    this
      ..replaceText(
        index,
        length,
        BlockEmbed.custom(embed),
        null,
      )
      ..editorFocusNode?.requestFocus()
      ..moveCursorToPosition(index + 1);
  }

  /// Insert formatted embed block [embed] into editor.
  ///
  /// Works like [insertEmbedBlock] but exists due to #2303 where should use
  /// [Embeddable] instead of [CustomBlockEmbed] as a workaround.
  ///
  /// refer: https://github.com/singerdmx/flutter-quill/issues/2303
  void insertEmbeddable(Embeddable embed) {
    this
      ..replaceText(
        index,
        length,
        embed,
        null,
      )
      ..editorFocusNode?.requestFocus()
      ..moveCursorToPosition(index + 1);
  }
}
