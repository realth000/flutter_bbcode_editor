import 'dart:convert';

import 'package:flutter_bbcode_editor/src/tags/embeddable.dart';
import 'package:flutter_bbcode_editor/src/tags/hide_v2/hide_v2_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Definition of hide v2 header.
///
/// Holding the points to see content or if is reply required.
final class BBCodeHideV2HeaderEmbed extends BBCodeEmbeddable {
  /// Constructor.
  BBCodeHideV2HeaderEmbed(BBCodeHideV2HeaderInfo data) : super(type: BBCodeHideV2Keys.headerType, data: data.toJson());
}

/// Embed data of hide v2 header.
final class BBCodeHideV2HeaderInfo {
  /// Constructor.
  const BBCodeHideV2HeaderInfo(this.points);

  /// Construct from [json] string.
  factory BBCodeHideV2HeaderInfo.fromJson(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    final points = switch (data) {
      {BBCodeHideV2Keys.points: final int data} => data,
      _ => throw Exception('bbcode hide v2 header points not found'),
    };
    return BBCodeHideV2HeaderInfo(points);
  }

  /// Create an empty hide info.
  ///
  /// For initialization or placeholder.
  factory BBCodeHideV2HeaderInfo.buildEmpty() => const BBCodeHideV2HeaderInfo(0);

  /// Parse a current type [embed] and add bbcode to [out].
  static void toBBCode(Embed embed, StringSink out) {
    final info = BBCodeHideV2HeaderInfo.fromJson(embed.value.data as String);
    final value = info.points > 0 ? '=${info.points}' : '';
    out.write('[hide$value]');
  }

  /// Points to see content.
  ///
  /// If is no more than 0, reply is required instead of points.
  final int points;

  /// Convert to json map string.
  String toJson() => jsonEncode(<String, dynamic>{BBCodeHideV2Keys.points: points});
}

/// Definition of hide v2 tail.
///
/// Hold nothing.
final class BBCodeHideV2TailEmbed extends BBCodeEmbeddable {
  /// Constructor.
  BBCodeHideV2TailEmbed() : super(type: BBCodeHideV2Keys.tailType, data: '');
}

/// Embed data for hide v2 tail.
final class BBCodeHideV2TailInfo {
  /// Constructor.
  const BBCodeHideV2TailInfo();

  /// Construct from [json] string.
  factory BBCodeHideV2TailInfo.fromJson(String _) {
    return const BBCodeHideV2TailInfo();
  }

  /// Parse a current type [embed] and add bbcode to [out].
  static void toBBCode(Embed embed, StringSink out) {
    out.write('[/hide]');
  }

  /// Convert to json map string.
  String toJson() => jsonEncode(<String, dynamic>{});
}
