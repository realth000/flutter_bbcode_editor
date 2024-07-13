import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';

/// Underline text.
///
/// ```bbcode
/// [u]$text[/u]
/// ```
final class UnderlineTag extends BBCodeTag {
  /// Constructor.
  const UnderlineTag();

  @override
  String get description => 'Underline Text';

  @override
  String get tagName => 'u';

  @override
  String get quillAttrName => 'underline';
}
