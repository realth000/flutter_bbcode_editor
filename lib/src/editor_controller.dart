part of 'editor.dart';

/// Function as portation button clicked callback.
typedef BBCodePortationButtonClickedCallback =
    FutureOr<void> Function(BuildContext context, BBCodeEditorController controller);

/// Alias type.
typedef BBCodeEditorController = QuillController;

/// Build a [BBCodeEditorController].
BBCodeEditorController buildBBCodeEditorController({bool readOnly = false, String? initialText, Delta? initialDelta}) {
  return QuillController(
    document:
        initialDelta != null
            ? Document.fromDelta(initialDelta)
            : initialText != null && initialText.isNotEmpty
            ? Document.fromDelta(Delta()..insert(initialText.endsWith('\n') ? initialText : '$initialText\n'))
            : Document(),
    selection: const TextSelection.collapsed(offset: 0),
    readOnly: readOnly,
  );
}

/// BBCode functionality extension on [QuillController].
extension BBCodeExt on BBCodeEditorController {
  /// A drop-in replacement for [clear] that does not request focus.
  ///
  /// Copied from the source of [clear] and ignore the focus.
  void clearWithoutRequestingFocus() {
    replaceText(
      0,
      plainTextEditingValue.text.length - 1,
      '',
      const TextSelection.collapsed(offset: 0),
      ignoreFocus: true,
    );
  }

  /// Convert current document to json format
  String toJson() => jsonEncode(document.toDelta().toJson());

  /// Set the document from json data.
  void setDocumentFromJson(List<dynamic> json) => document = Document.fromJson(json);

  /// Set the document from quill delta.
  void setDocumentFromDelta(Delta delta) {
    if (delta.isEmpty) {
      delta.insert('\n');
    } else {
      // Make sure delta ended with new line.
      final lastOp = delta.operations.lastOrNull;
      final lastOpData = lastOp?.data;
      if (lastOp == null || lastOp.data == null || lastOpData is! String || !lastOpData.endsWith('\n')) {
        delta.operations.add(Operation.insert('\n'));
      }
    }

    document = Document.fromDelta(delta);
  }

  /// Set the document from raw text without format.
  void setDocumentFromRawText(String text) {
    final String fixedText;
    if (text.endsWith('\n')) {
      fixedText = text;
    } else {
      fixedText = '$text\n';
    }
    document = Document.fromDelta(Delta.fromOperations([Operation.insert(fixedText)]));
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
  String toBBCode({bool trimCR = true}) {
    final converter = DeltaToBBCode();
    var ret = converter.convert(document.toDelta());
    if (trimCR) {
      ret = ret.replaceAll('\r', '');
    }
    if (ret.endsWith('\n')) {
      return ret.substring(0, ret.length - 1);
    }
    return ret;
  }

  /// Convert current document to quill delta json object.
  List<Map<String, dynamic>> toQuillDeltaJson({bool trimCR = true}) {
    if (!trimCR) {
      return document.toDelta().toJson();
    }

    return document
        .toDelta()
        .operations
        .map(
          (op) => jsonDecode(jsonEncode(op.toJson()).replaceAll('\r', '')) as Map<String, dynamic>,
        )
        .toList();
  }

  /// Convert current document to quill delta.
  String toQuillDelta({bool trimCR = true}) {
    final data = jsonEncode(document.toDelta().toJson());
    return trimCR ? data.replaceAll('\r', '') : data;
  }

  /// Insert plain [text] into current cursor position, no formatting, no attributes.
  void insertPlainText(String text, {bool trimCR = true}) {
    final data = switch (trimCR) {
      true => text.replaceAll('\r', ''),
      false => text,
    };
    final position = selection.baseOffset;
    final length = selection.extentOffset - position;
    this
      ..replaceText(position, length, data, null)
      ..moveCursorToPosition(position + data.length);
  }

  /// Insert [text] into current cursor position and format with [attr].
  void insertFormattedText(String text, Attribute<dynamic> attr, {bool trimCR = true}) {
    final data = switch (trimCR) {
      true => text.replaceAll('\r', ''),
      false => text,
    };
    final position = selection.baseOffset;
    final length = selection.extentOffset - position;
    this
      ..replaceText(position, length, data, null)
      ..formatText(position, data.length, attr)
      ..moveCursorToPosition(position + data.length);
  }

  /// Insert raw bbcode that has a [head] and [tail] and move cursor to the
  /// position between them after insertion.
  void insertRawCode(String head, String tail) {
    final position = selection.baseOffset;
    final length = selection.extentOffset - position;
    this
      ..replaceText(position, length, head + tail, null)
      ..moveCursorToPosition(position + head.length);
  }

  /// Insert formatted embed block [embed] into editor.
  void insertEmbedBlock(CustomBlockEmbed embed) {
    final position = selection.baseOffset;
    final length = selection.extentOffset - position;
    this
      ..replaceText(position, length, BlockEmbed.custom(embed), null)
      ..moveCursorToPosition(position + 1);
  }

  /// Insert formatted embed block [embed] into editor.
  ///
  /// Works like [insertEmbedBlock] but exists due to #2303 where should use
  /// [Embeddable] instead of [CustomBlockEmbed] as a workaround.
  ///
  /// refer: https://github.com/singerdmx/flutter-quill/issues/2303
  void insertEmbeddable(Embeddable embed) {
    final position = selection.baseOffset;
    final length = selection.extentOffset - position;
    this
      ..replaceText(position, length, embed, null)
      ..moveCursorToPosition(position + 1);
  }

  /// Insert bbcode text in the cursor position.
  void insertBBCode(String bbcode, {bool trimCR = true}) {
    final code = switch (trimCR) {
      true => bbcode.replaceAll('\r', ''),
      false => bbcode,
    };
    final position = selection.baseOffset;
    final length = selection.extentOffset - position;
    var delta = parseBBCodeTextToDelta(code);
    final lastOp = delta.operations.lastOrNull;
    if (lastOp == null) {
      // Do noting if operation is empty.
      return;
    }
    // Remove the trailing space because the space may be added by editor not user.
    // Note that if user manually ends the text with '\n', we can not tell if the trailing '\n' is inserted by editor
    // or not, this issue occurs everywhere we process text content.
    //
    // Do not remove the trailing '\n' if the operation has attribute: where it's definitely not added by editor for
    // format purpose.
    if ((lastOp.attributes?.isEmpty ?? true) && lastOp.data != null && lastOp.data is String) {
      final lastOpStr = lastOp.data! as String;
      if (lastOpStr.length == 1 && lastOpStr.endsWith('\n')) {
        delta = Delta.fromOperations(List.from(delta.operations)..removeLast());
      }
    }

    replaceText(position, length, delta, null);
    moveCursorToPosition(position);
  }
}
