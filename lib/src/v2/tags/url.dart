import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';

/// Url attached on text.
///
/// ```bbcode
/// [url=$link]$text[/url]
/// ```
///
/// Or
///
/// ```bbcode
/// [url=$link]$link[/url].
/// ```
final class UrlTag extends BBCodeTag {
  /// Constructor.
  const UrlTag();

  @override
  String get description => 'Url';

  @override
  String get quillAttrName => 'link';

  @override
  String get tagName => 'url';

  @override
  String toBBCode(String text, dynamic attribute) {
    if (attribute is String) {
      return '[$tagName=$attribute]$text[/$tagName]';
    }

    return text;
  }
}
