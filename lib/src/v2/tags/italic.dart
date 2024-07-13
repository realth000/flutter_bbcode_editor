import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';

/// Italic text.
///
/// ```bbcode
/// [i]$text[/i]
/// ```
final class ItalicTag extends BBCodeTag {
  /// Constructor.
  const ItalicTag();

  @override
  String get description => 'Italic text';

  @override
  String get tagName => 'i';

  @override
  String get quillAttrName => 'italic';
}
