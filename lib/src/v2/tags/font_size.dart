import 'package:collection/collection.dart';
import 'package:flutter_bbcode_editor/src/v2/constants.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';

/// Font size text.
///
/// ```bbcode
/// [size=$size]$text[/size]
/// ```
final class FontSizeTag extends BBCodeTag {
  /// Constructor.
  const FontSizeTag();

  @override
  String get description => 'Font Size';

  @override
  String get quillAttrName => 'size';

  @override
  String get tagName => 'size';

  @override
  bool validateAttribute(dynamic attr) =>
      attr is String && defaultFontSizeMap.containsKey(attr);

  @override
  String toBBCode(String text, dynamic attribute) {
    if (attribute is double) {
      // TODO: Dynamic font size.
      final fontSizeLevel = defaultFontSizeMap.entries
          .firstWhereOrNull((e) => e.value == '$attribute')
          ?.key;
      if (fontSizeLevel != null) {
        return '[$tagName=$fontSizeLevel]$text[/$tagName]';
      }
    }

    return super.toBBCode(text, attribute);
  }
}
