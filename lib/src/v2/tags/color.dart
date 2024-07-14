import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';
import 'package:flutter_bbcode_editor/src/v2/utils.dart';

/// Text color.
///
/// ```bbcode
/// [color=$color]$text[/color]
/// ```
final class ColorTag extends BBCodeTag {
  /// Constructor.
  const ColorTag();

  @override
  String get description => 'Text Color';

  @override
  String get quillAttrName => 'color';

  @override
  String get tagName => 'color';

  @override
  bool validateAttribute(String attr) => ColorUtils.isColor(attr);

  @override
  String toBBCode(String text, dynamic attribute) {
    if (attribute is String) {
      if (ColorUtils.isColor(attribute)) {
        return '[$tagName=${ColorUtils.toBBCodeColor(attribute)}]$text[/$tagName]';
      }
    }
    return text;
  }
}
