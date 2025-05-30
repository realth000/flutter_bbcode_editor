import 'dart:convert';

import 'package:flutter_bbcode_editor/src/tags/embeddable.dart';
import 'package:flutter_bbcode_editor/src/tags/free/free_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Definition of free header.
///
/// Hold nothing.
final class BBCodeFreeHeaderEmbed extends BBCodeEmbeddable {
  /// Constructor.
  BBCodeFreeHeaderEmbed(BBCodeFreeHeaderInfo data) : super(type: BBCodeFreeKeys.headerType, data: data.toJson());
}

/// Embed data for free head.
final class BBCodeFreeHeaderInfo {
  /// Constructor.
  const BBCodeFreeHeaderInfo();

  /// Construct from [json] string.
  factory BBCodeFreeHeaderInfo.fromJson(String _) {
    return const BBCodeFreeHeaderInfo();
  }

  /// Parse a current type [embed] and add bbcode to [out].
  static void toBBCode(Embed embed, StringSink out) {
    out.write('[free]');
  }

  /// Convert to json map string.
  String toJson() => jsonEncode(<String, dynamic>{});
}

/// Definition of free tail.
///
/// Hold nothing.
final class BBCodeFreeTailEmbed extends BBCodeEmbeddable {
  /// Constructor.
  BBCodeFreeTailEmbed(BBCodeFreeTailInfo data) : super(type: BBCodeFreeKeys.tailType, data: data.toJson());
}

/// Embed data for free tail.
final class BBCodeFreeTailInfo {
  /// Constructor.
  const BBCodeFreeTailInfo();

  /// Construct from [json] string.
  factory BBCodeFreeTailInfo.fromJson(String _) {
    return const BBCodeFreeTailInfo();
  }

  /// Parse a current type [embed] and add bbcode to [out].
  static void toBBCode(Embed embed, StringSink out) {
    out.write('[/free]');
  }

  /// Convert to json map string.
  String toJson() => jsonEncode(<String, dynamic>{});
}
