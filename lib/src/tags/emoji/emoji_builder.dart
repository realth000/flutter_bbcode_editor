import 'package:flutter/widgets.dart';
import 'package:flutter_bbcode_editor/src/tags/emoji/emoji_embed.dart';
import 'package:flutter_bbcode_editor/src/tags/emoji/emoji_keys.dart';
import 'package:flutter_bbcode_editor/src/types.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Editor widget builder for emoji.
final class BBCodeEmojiEmbedBuilder extends EmbedBuilder {
  /// Constructor.
  BBCodeEmojiEmbedBuilder({required this.emojiProvider});

  /// Injected emoji provider.
  final BBCodeEmojiProvider emojiProvider;

  /// Map of emoji code and calculated widget.
  final _emojiCacheMap = <String, Widget>{};

  @override
  bool get expanded => false;

  @override
  String get key => BBCodeEmojiKeys.type;

  @override
  Widget build(
    BuildContext context,
    EmbedContext embedContext,
  ) {
    final info =
        BBCodeEmojiInfo.fromJson(embedContext.node.value.data as String);
    final code = info.code;
    if (!_emojiCacheMap.containsKey(code)) {
      _emojiCacheMap[code] = emojiProvider(context, code);
    }
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 2),
      child: _emojiCacheMap[code],
    );
  }
}
