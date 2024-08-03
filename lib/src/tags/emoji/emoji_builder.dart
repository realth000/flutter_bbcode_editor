import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/tags/emoji/emoji_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

// TODO: Async?
/// External function, provide emoji image from bbcode [code].
typedef BBCodeEmojiProvider = Widget Function(
  BuildContext context,
  String code,
);

/// Editor widget builder for embed emoji types.
///
final class BBCodeEmojiEmbedBuilder extends EmbedBuilder {
  /// Constructor.
  BBCodeEmojiEmbedBuilder({required this.emojiProvider});

  /// Injected emoji provider.
  final BBCodeEmojiProvider emojiProvider;

  Widget? _emojiCache;

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
    if (_emojiCache == null) {
      final data =
          jsonDecode(node.value.data as String) as Map<String, dynamic>;
      final code = data[BBCodeEmojiKeys.code] as String;
      _emojiCache = emojiProvider(context, code);
    }
    return _emojiCache!;
  }
}
