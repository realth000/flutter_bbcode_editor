part of 'editor.dart';

/// All default supported and enabled bbcode tags.
final defaultBBCodeTags = <BBCodeTag>{
  const BoldTag(),
  const ItalicTag(),
  const UnderlineTag(),
  const StrikethroughTag(),
  const FontSizeTag(),
  const ColorTag(),
  const BackgroundColorTag(),
  const CodeBlockTag(),
  const QuoteBlockTag(),
  const UrlTag(),
  const FontFamilyTag(),
  const ScriptTag(),
  const AlignLeftTag(),
  const AlignCenterTag(),
  const AlignRightTag(),
};

/// V2 editor controller.
final class BBCodeEditorController extends ValueNotifier<BBCodeEditorValue> {
  /// Constructor.
  BBCodeEditorController({
    Set<BBCodeTag>? tags,
  })  : tags = tags ?? defaultBBCodeTags,
        super(BBCodeEditorValue());

  /// Underlying quill editor controller.
  final QuillController _quillController = QuillController.basic();

  /// All available bbcode tags.
  ///
  /// Each [BBCodeTag] represents a kind of bbcode tag.
  final Set<BBCodeTag> tags;

  /// Convert current document to json format
  String toJson() => jsonEncode(_quillController.document.toDelta().toJson());

  /// Set the document from json data.
  void setDocumentFromJson(List<dynamic> json) =>
      _quillController.document = Document.fromJson(json);

  /// Convert current document to bbcode.
  String toBBCode() {
    final converter = DeltaToBBCode();
    final ret = converter.convert(_quillController.document.toDelta());
    print('>> >ret=$ret');
    return ret;

    // r
    final context = BBCodeTagContext();

    final rawJson = _quillController.document.toDelta().toJson();
    print('>>> DOC: ${jsonEncode(rawJson)}');

    // Parse operations from end to start, see BBCodeTagContext for details.
    final op = _quillController.document.toDelta().operations;
    return op.reversed
        .mapIndexed(
          (index, e) => e.toBBCode(
            context,
            tags,
            removeLastLineFeed: index == 0,
            // Pop all block at the last node.
            popAllBlock: index == op.length - 1,
          ),
        )
        .toList()
        .reversed
        .join();
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
