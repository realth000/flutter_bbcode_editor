import 'dart:convert';

import 'package:flutter_bbcode_editor/src/tags/embeddable.dart';
import 'package:flutter_bbcode_editor/src/tags/emoji/emoji_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

// FIXME: Waiting for upstream fix. Should derive from CustomEmbedBlock.
/// Definition of emoji used in bbcode editor.
final class BBCodeEmojiEmbed extends BBCodeEmbeddable {
  /// Constructor.
  BBCodeEmojiEmbed(BBCodeEmojiInfo data)
      : super(type: BBCodeEmojiKeys.type, data: data.toJson());

  /// Construct from emoji info.
  factory BBCodeEmojiEmbed.raw(String code) =>
      BBCodeEmojiEmbed(BBCodeEmojiInfo(code: code));
}

/// Emoji info saved in editor.
final class BBCodeEmojiInfo {
  /// Constructor.
  BBCodeEmojiInfo({required this.code});

  /// Construct from [json] string.
  factory BBCodeEmojiInfo.fromJson(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    return BBCodeEmojiInfo(code: data[BBCodeEmojiKeys.code] as String);
  }

  /// Converter to bbcode.
  static void toBBCode(Embed embed, StringSink out) {
    final d1 = BBCodeEmojiInfo.fromJson(embed.value.data as String);
    out.write(d1.code);
  }

  /// Convert to json string.
  String toJson() => jsonEncode(<String, dynamic>{
        BBCodeEmojiKeys.code: code,
      });

  /// Emoji code.
  ///
  /// {:10_234:}
  final String code;
}
