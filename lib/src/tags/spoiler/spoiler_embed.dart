import 'dart:convert';

import 'package:flutter_bbcode_editor/src/convert/to_bbcode.dart';
import 'package:flutter_bbcode_editor/src/tags/embeddable.dart';
import 'package:flutter_bbcode_editor/src/tags/spoiler/spoiler_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

/// Definition of spoiler area used in bbcode editor.
///
/// A spoiler is an area that can be collapsed and expanded by clicking the
/// button on it.
final class BBCodeSpoilerEmbed extends BBCodeEmbeddable {
  /// Constructor.
  BBCodeSpoilerEmbed(BBCodeSpoilerInfo data) : super(type: BBCodeSpoilerKeys.type, data: data.toJson());
}

/// Data class carrying spoiler info.
final class BBCodeSpoilerInfo {
  /// Constructor.
  const BBCodeSpoilerInfo({required this.title, required this.body, required this.collapsed});

  /// Construct from [json] string.
  factory BBCodeSpoilerInfo.fromJson(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    final title = switch (data) {
      {BBCodeSpoilerKeys.title: final String data} => data,
      _ => throw Exception('bbcode spoiler title not found'),
    };
    final body = switch (data) {
      {BBCodeSpoilerKeys.body: final String data} => data,
      _ => throw Exception('bbcode spoiler body not found'),
    };
    final collapsed = switch (data) {
      {BBCodeSpoilerKeys.collapsed: final bool data} => data,
      _ => true,
    };

    return BBCodeSpoilerInfo(title: title, body: body, collapsed: collapsed);
  }

  /// Create an empty spoiler info.
  ///
  /// For initialization or placeholder.
  ///
  /// The [title] should be constructed according to current locale and built to
  /// be a default value, usually injected with l10n on build context.
  factory BBCodeSpoilerInfo.buildEmpty(String title) => BBCodeSpoilerInfo(title: title, body: '', collapsed: true);

  /// Parse a current type [embed] and add bbcode to [out].
  static void toBBCode(Embed embed, StringSink out) {
    final info = BBCodeSpoilerInfo.fromJson(embed.value.data as String);
    final bbcode = DeltaToBBCode().convert(Delta.fromJson(jsonDecode(info.body) as List<dynamic>));
    out.write('[spoiler=${info.title}]$bbcode[/spoiler]');
  }

  /// Plain text title to show when collapsed.
  final String title;

  /// Raw bbcode body in the spoiler area
  final String body;

  /// Spoiler is collapsed or not
  ///
  /// Only a flag indicating should expand the spoiler card or not when
  /// rendering into an editor. Not be into the generated bbcode.
  ///
  /// This field is optional, meaning it's a field added later in release, make
  /// it optional to keep compatible with old version documents.
  ///
  /// Default value is true.
  final bool collapsed;

  /// Convert to json map string.
  String toJson() => jsonEncode(<String, dynamic>{
    BBCodeSpoilerKeys.title: title,
    BBCodeSpoilerKeys.body: body,
    BBCodeSpoilerKeys.collapsed: collapsed,
  });

  /// The copy with method.
  BBCodeSpoilerInfo copyWith({String? title, String? body, bool? collapsed}) {
    return BBCodeSpoilerInfo(
      title: title ?? this.title,
      body: body ?? this.body,
      collapsed: collapsed ?? this.collapsed,
    );
  }

  @override
  String toString() =>
      '${BBCodeSpoilerKeys.title}=$title, '
      '${BBCodeSpoilerKeys.body}=$body, '
      '${BBCodeSpoilerKeys.collapsed}=$collapsed';
}
