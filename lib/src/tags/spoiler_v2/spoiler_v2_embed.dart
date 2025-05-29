import 'dart:convert';

import 'package:flutter_bbcode_editor/src/tags/embeddable.dart';
import 'package:flutter_bbcode_editor/src/tags/spoiler_v2/spoiler_v2_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Definition of spoiler v2 header.
///
/// Holding the outer hint text for spoiler.
final class BBCodeSpoilerV2HeaderEmbed extends BBCodeEmbeddable {
  /// Constructor.
  BBCodeSpoilerV2HeaderEmbed(BBCodeSpoilerV2HeaderInfo data)
    : super(type: BBCodeSpoilerV2Keys.headerType, data: data.toJson());
}

/// Embed data for spoiler v2 header.
final class BBCodeSpoilerV2HeaderInfo {
  /// Constructor.
  const BBCodeSpoilerV2HeaderInfo(this.title);

  /// Construct from [json] string.
  factory BBCodeSpoilerV2HeaderInfo.fromJson(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;

    final title = switch (data) {
      {BBCodeSpoilerV2Keys.title: final String data} => data,
      _ => throw Exception('bbcode spoiler v2 header title not found'),
    };

    return BBCodeSpoilerV2HeaderInfo(title);
  }

  /// Parse a current type [embed] and add bbcode to [out].
  static void toBBCode(Embed embed, StringSink out) {
    final info = BBCodeSpoilerV2HeaderInfo.fromJson(embed.value.data as String);
    out.write('[spoiler=${info.title}]');
  }

  /// The title of spoiler.
  final String title;

  /// Convert to json map string.
  String toJson() => jsonEncode(<String, dynamic>{BBCodeSpoilerV2Keys.title: title});
}

/// Definition of spoiler v2 tail.
///
/// Hold nothing.
final class BBCodeSpoilerV2TailEmbed extends BBCodeEmbeddable {
  /// Constructor.
  BBCodeSpoilerV2TailEmbed() : super(type: BBCodeSpoilerV2Keys.tailType, data: '');
}

/// Embed data for spoiler v2 tail.
final class BBCodeSpoilerV2TailInfo {
  /// Constructor.
  const BBCodeSpoilerV2TailInfo();

  /// Construct from [json] string.
  factory BBCodeSpoilerV2TailInfo.fromJson(String _) {
    return const BBCodeSpoilerV2TailInfo();
  }

  /// Parse a current type [embed] and add bbcode to [out].
  static void toBBCode(Embed embed, StringSink out) {
    out.write('[/spoiler]');
  }

  /// Convert to json map string.
  String toJson() => jsonEncode(<String, dynamic>{});
}
