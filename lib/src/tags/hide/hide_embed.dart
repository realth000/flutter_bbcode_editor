import 'dart:convert';

import 'package:flutter_bbcode_editor/src/convert/to_bbcode.dart';
import 'package:flutter_bbcode_editor/src/tags/embeddable.dart';
import 'package:flutter_bbcode_editor/src/tags/hide/hide_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

/// Definition of hide area used in bbcode editor.
///
/// A hide is an area that can keeps hide until user meets one of the following
/// conditions
///
/// * Replied to this thread.
/// * Have points more than the minimum value.
final class BBCodeHideEmbed extends BBCodeEmbeddable {
  /// Constructor.
  BBCodeHideEmbed(BBCodeHideInfo data) : super(type: BBCodeHideKeys.type, data: data.toJson());
}

/// Data class carrying hide info.
final class BBCodeHideInfo {
  /// Constructor.
  const BBCodeHideInfo({required this.points, required this.body});

  /// Construct from [json] string.
  factory BBCodeHideInfo.fromJson(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    final points = switch (data) {
      {BBCodeHideKeys.points: final int data} => data,
      _ => throw Exception('bbcode hide points not found'),
    };
    final body = switch (data) {
      {BBCodeHideKeys.body: final String data} => data,
      _ => throw Exception('bbcode hide body not found'),
    };

    return BBCodeHideInfo(points: points, body: body);
  }

  /// Create an empty hide info.
  ///
  /// For initialization or placeholder.
  factory BBCodeHideInfo.buildEmpty() => const BBCodeHideInfo(points: 0, body: '');

  /// Parse a current type [embed] and add bbcode to [out].
  static void toBBCode(Embed embed, StringSink out) {
    final info = BBCodeHideInfo.fromJson(embed.value.data as String);
    final bbcode = DeltaToBBCode().convert(Delta.fromJson(jsonDecode(info.body) as List<dynamic>));
    final value = info.points > 0 ? '=${info.points}' : '';
    out.write('[hide$value]${bbcode.trimRight()}[/hide]');
  }

  /// Minimum points to see the hide content.
  ///
  /// If points is zero or less than zero, means user need to reply to see the
  /// content instead of holding enough points.
  ///
  /// But hide with reply only works for a thread, aka in the first floor of
  /// thread.
  final int points;

  /// Raw bbcode body in the hide area
  final String body;

  /// Convert to json map string.
  String toJson() => jsonEncode(<String, dynamic>{BBCodeHideKeys.points: points, BBCodeHideKeys.body: body});

  @override
  String toString() =>
      '${BBCodeHideKeys.points}=$points, '
      '${BBCodeHideKeys.body}=$body';
}
