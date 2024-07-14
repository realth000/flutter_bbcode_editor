import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';
import 'package:flutter_bbcode_editor/src/v2/utils.dart';

/// Text background color.
///
/// ```bbcode
/// [backcolor=$color]$text[/backcolor].
/// ```
final class BackgroundColorTag extends BBCodeTag {
  /// Constructor.
  const BackgroundColorTag();

  @override
  String get description => 'Background Color';

  @override
  String get quillAttrName => 'background';

  @override
  String get tagName => 'backcolor';

  @override
  bool validateAttribute(dynamic attr) =>
      attr is String && ColorUtils.isColor(attr);

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
