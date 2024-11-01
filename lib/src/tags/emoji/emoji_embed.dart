import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_quill/flutter_quill.dart';

// FIXME: Waiting for upstream fix. Should derive from CustomEmbedBlock.
/// Definition of emoji used in bbcode editor.
final class BBCodeEmojiEmbed extends Embeddable {
  /// Constructor.
  BBCodeEmojiEmbed(String data) : super(bbcodeImageType, data);

  /// Construct from emoji info.
  factory BBCodeEmojiEmbed.fromInfo(String code) => BBCodeEmojiEmbed(code);

  /// Embed type.
  static const bbcodeImageType = BBCodeEmbedTypes.emoji;

  /// Get the quill document.
  String get code => data as String;
}
