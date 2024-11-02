import 'dart:convert';

import 'package:flutter_bbcode_editor/src/tags/embeddable.dart';
import 'package:flutter_bbcode_editor/src/tags/image/image_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

// FIXME: Waiting for upstream fix. Should derive from CustomEmbedBlock.
/// Definition of image used in bbcode editor.
final class BBCodeImageEmbed extends BBCodeEmbeddable {
  /// Constructor.
  BBCodeImageEmbed(BBCodeImageInfo data)
      : super(type: BBCodeImageKeys.type, data: data.toJson());
}

final class BBCodeImageInfo {
  const BBCodeImageInfo(
    this.link, {
    this.width,
    this.height,
  });

  factory BBCodeImageInfo.fromJson(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    final link = switch (data) {
      {BBCodeImageKeys.link: final String data} => data,
      _ => null,
    };
    assert(link != null, 'Link in Image delta json MUST NOT a String');

    final width = switch (data) {
      {BBCodeImageKeys.width: final int? data} => data,
      _ => null,
    };
    final height = switch (data) {
      {BBCodeImageKeys.height: final int? data} => data,
      _ => null,
    };

    return BBCodeImageInfo(
      link!,
      width: width,
      height: height,
    );
  }

  final String link;
  final int? width;
  final int? height;

  String toJson() => jsonEncode(<String, dynamic>{
        BBCodeImageKeys.link: link,
        BBCodeImageKeys.width: width,
        BBCodeImageKeys.height: height,
      });

  static void toBBCode(Embed embed, StringSink out) {
    final imageInfo = BBCodeImageInfo.fromJson(embed.value.data as String);
    out.write('[img=${imageInfo.width},${imageInfo.height}]'
        '${imageInfo.link}'
        '[/img]');
  }

  BBCodeImageInfo copyWith({
    String? link,
    int? width,
    int? height,
  }) {
    return BBCodeImageInfo(
      link ?? this.link,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  String toString() => '${BBCodeImageKeys.link}=$link, '
      '${BBCodeImageKeys.width}=$width, '
      '${BBCodeImageKeys.height}=$height';
}
