import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/tags/divider/divider_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Editor widget builder for embed divider types.
final class BBCodeDividerEmbedBuilder extends EmbedBuilder {
  @override
  String get key => BBCodeDividerKeys.type;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    return const Divider();
  }
}
