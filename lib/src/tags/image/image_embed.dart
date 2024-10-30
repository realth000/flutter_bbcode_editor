import 'dart:convert';

import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';
import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Definition of image used in bbcode editor.
final class BBCodeImageEmbed extends CustomBlockEmbed {
  /// Constructor.
  BBCodeImageEmbed(BBCodeImageInfo value)
      : super(bbcodeImageType, jsonEncode(value.toJson()));

  /// Construct from image info.
  factory BBCodeImageEmbed.fromInfo(BBCodeImageInfo info) =>
      BBCodeImageEmbed(info);

  /// Embed type.
  static const bbcodeImageType = BBCodeEmbedTypes.image;

  /// Get the quill document.
  BBCodeImageInfo get info => BBCodeImageInfo.fromJson(
        jsonDecode(data as String) as Map<String, dynamic>,
      );
}
