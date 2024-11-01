import 'dart:convert';

import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_quill/flutter_quill.dart';

// FIXME: Waiting for upstream fix. Should derive from CustomEmbedBlock.
/// Definition of image used in bbcode editor.
final class BBCodeUserMentionEmbed extends Embeddable {
  /// Constructor.
  const BBCodeUserMentionEmbed(String value) : super(embedType, value);

  /// Construct from quill document.
  factory BBCodeUserMentionEmbed.fromDocument(Document document) =>
      BBCodeUserMentionEmbed(jsonEncode(document.toDelta().toJson()));

  /// Embed type.
  static const embedType = BBCodeEmbedTypes.userMention;

  /// Get the quill document.
  Document get document =>
      Document.fromJson(jsonDecode(data as String) as List);
}
