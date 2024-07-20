import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_bbcode_editor/src/v2/constants.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/emoji/emoji_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// External function, provide emoji image from bbcode [code].
typedef BBCodeEmojiProvider = Widget Function(
  BuildContext context,
  String code,
);

/// Editor widget builder for embed emoji types.
///
final class BBCodeEmojiEmbedBuilder extends EmbedBuilder {
  /// Constructor.
  const BBCodeEmojiEmbedBuilder({required this.emojiProvider});

  /// Injected emoji provider.
  final BBCodeEmojiProvider emojiProvider;

  @override
  bool get expanded => false;

  @override
  String get key => BBCodeEmbedTypes.emoji;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final data = jsonDecode(node.value.data as String) as Map<String, dynamic>;
    final code = data[BBCodeEmojiKeys.code] as String;
    return emojiProvider(context, code);
  }
}
