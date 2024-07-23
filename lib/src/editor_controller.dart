part of 'editor.dart';

/// V2 editor controller.
final class BBCodeEditorController extends ValueNotifier<BBCodeEditorValue> {
  /// Constructor.
  BBCodeEditorController() : super(BBCodeEditorValue());

  /// Underlying quill editor controller.
  final QuillController _quillController = QuillController.basic();

  /// Convert current document to json format
  String toJson() => jsonEncode(_quillController.document.toDelta().toJson());

  /// Set the document from json data.
  void setDocumentFromJson(List<dynamic> json) =>
      _quillController.document = Document.fromJson(json);

  /// Convert current document to bbcode.
  String toBBCode() {
    final converter = DeltaToBBCode();
    final ret = converter.convert(_quillController.document.toDelta());
    return ret;
  }

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
      ..skipRequestKeyboard = true
      ..replaceText(
        _quillController.index,
        _quillController.length,
        BlockEmbed.custom(CustomBlockEmbed(embedType, data)),
        null,
      )
      ..moveCursorToPosition(_quillController.index + 1);
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }
}
