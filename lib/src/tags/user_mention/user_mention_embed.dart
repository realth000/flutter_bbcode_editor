import 'dart:convert';

import 'package:flutter_bbcode_editor/src/tags/user_mention/user_mention_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

// FIXME: Waiting for upstream fix. Should derive from CustomEmbedBlock.
/// Definition of image used in bbcode editor.
final class BBCodeUserMentionEmbed extends Embeddable {
  /// Constructor.
  BBCodeUserMentionEmbed(BBCodeUserMentionInfo data) : super(BBCodeUserMentionKeys.type, data.toJson());

  /// Construct from quill document.
  factory BBCodeUserMentionEmbed.raw({required String username}) =>
      BBCodeUserMentionEmbed(BBCodeUserMentionInfo(username: username));
}

/// Data class carrying user mention data.
class BBCodeUserMentionInfo {
  /// Constructor.
  const BBCodeUserMentionInfo({required this.username});

  /// Build from json.
  ///
  /// ```json
  /// {
  ///   "username": $USERNAME
  /// }
  /// ```
  factory BBCodeUserMentionInfo.fromJson(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    return BBCodeUserMentionInfo(username: data[BBCodeUserMentionKeys.username] as String);
  }

  /// Parse en current type [embed] and add bbcode to [out].
  static void toBBCode(Embed embed, StringSink out) {
    final info = BBCodeUserMentionInfo.fromJson(embed.value.data as String);
    out.write('[@]${info.username}[/@]');
  }

  /// User name to mention.
  final String username;

  /// Convert info json.
  String toJson() => jsonEncode(<String, dynamic>{BBCodeUserMentionKeys.username: username});

  @override
  String toString() => 'BBCodeUserMentionInfo{ username=$username }';
}
