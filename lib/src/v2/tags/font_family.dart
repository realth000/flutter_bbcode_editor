import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';

/// Text font family.
///
/// ```bbcode
/// [font=$font_family]$text[/font].
/// ```
final class FontFamilyTag extends BBCodeTag {
  /// Constructor.
  const FontFamilyTag();

  @override
  String get description => 'Font Family';

  @override
  String get quillAttrName => 'font';

  @override
  String get tagName => 'font';

  @override
  String toBBCode(String text, dynamic attribute) {
    if (attribute is String) {
      return '[$tagName=$attribute]$text[/$tagName]';
    }
    return super.toBBCode(text, attribute);
  }
}
