import 'dart:convert';

import 'package:flutter_bbcode_editor/src/tags/embeddable.dart';
import 'package:flutter_bbcode_editor/src/tags/image/image_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

// FIXME: Waiting for upstream fix. Should derive from CustomEmbedBlock.
/// Definition of image used in bbcode editor.
final class BBCodeImageEmbed extends BBCodeEmbeddable {
  /// Constructor.
  BBCodeImageEmbed(BBCodeImageInfo data) : super(type: BBCodeImageKeys.type, data: data.toJson());
}

/// Data class carrying image embed info.
final class BBCodeImageInfo {
  /// Constructor.
  const BBCodeImageInfo(
    this.link, {
    this.width,
    this.height,
  });

  /// Construct from [json] string.
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

  /// Image url.
  final String link;

  /// Image width.
  ///
  /// This width is the one set by user, not the image's original width.
  ///
  /// Used to set image size when converting to bbcode.
  final int? width;

  /// Image height.
  ///
  /// This height is the one set by user, not the image's original height.
  ///
  /// Used to set image size when converting to bbcode.
  final int? height;

  /// Convert to json string.
  String toJson() => jsonEncode(<String, dynamic>{
        BBCodeImageKeys.link: link,
        BBCodeImageKeys.width: width,
        BBCodeImageKeys.height: height,
      });

  /// Parse en current type [embed] and add bbcode to [out].
  static void toBBCode(Embed embed, StringSink out) {
    final imageInfo = BBCodeImageInfo.fromJson(embed.value.data as String);
    final w = imageInfo.width ?? 0;
    final h = imageInfo.height ?? 0;
    final comma = imageInfo.width != null && imageInfo.height != null ? ',' : '';
    final String attr;
    if (w > 0 && h > 0) {
      attr = '=$w$comma$h';
    } else {
      attr = '';
    }
    out.write('[img$attr]${imageInfo.link}[/img]');
  }

  @override
  String toString() => '${BBCodeImageKeys.link}=$link, '
      '${BBCodeImageKeys.width}=$width, '
      '${BBCodeImageKeys.height}=$height';
}
