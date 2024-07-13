import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/v2/editor_value.dart';
import 'package:flutter_bbcode_editor/src/v2/extensions/to_bbcode.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/bold.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/font_size.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/italic.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/strikethrough.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/underline.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// All default supported and enabled bbcode tags.
final defaultBBCodeTags = <BBCodeTag>{
  const BoldTag(),
  const ItalicTag(),
  const UnderlineTag(),
  const StrikethroughTag(),
  const FontSizeTag(),
};

/// V2 editor controller.
final class BBCodeEditorController extends ValueNotifier<BBCodeEditorValue> {
  /// Constructor.
  BBCodeEditorController({
    Set<BBCodeTag>? tags,
  })  : tags = tags ?? defaultBBCodeTags,
        super(BBCodeEditorValue());

  /// Underlying quill editor controller.
  final QuillController quillController = QuillController.basic();

  /// All available bbcode tags.
  ///
  /// Each [BBCodeTag] represents a kind of bbcode tag.
  final Set<BBCodeTag> tags;

  /// Convert current document to bbcode.
  String toBBCode() {
    final context = BBCodeTagContext();

    final rawJson = quillController.document.toDelta().toJson();
    print('>>> DOC=${jsonEncode(rawJson)}');

    print('>>> ---------------------------');

    return quillController.document
        .toDelta()
        .operations
        .map((e) => e.toBBCode(context, tags))
        .toList()
        .join();
  }

  @override
  void dispose() {
    quillController.dispose();
    super.dispose();
  }
}
