import 'package:flutter_bbcode_editor/src/tags/divider/divider_keys.dart';
import 'package:flutter_bbcode_editor/src/tags/embeddable.dart';
import 'package:flutter_quill/flutter_quill.dart';

// TODO: Use block instead of embed.
/// Definition of divider used in bbcode editor.
///
/// A divider is a horizontal line that occupies a whole row.
///
/// ht tag in bbcode and html
final class BBCodeDividerEmbed extends BBCodeEmbeddable {
  /// Constructor.
  BBCodeDividerEmbed() : super(type: BBCodeDividerKeys.type, data: 'hr');

  /// Parse a current type [embed] and add bbcode to [out].
  ///
  /// Generally this function is in info types but divider is too simple to have
  /// one.
  static void toBBCode(Embed embed, StringSink out) => out.write('[hr]');
}
