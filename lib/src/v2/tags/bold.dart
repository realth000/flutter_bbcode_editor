import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';

/// Bold text.
///
/// ```bbcode
/// [b]$text[/b]
/// ```
final class BoldTag extends BBCodeTag {
  /// Constructor.
  const BoldTag();

  @override
  String get description => 'Bold Text';

  @override
  String get tagName => 'b';

  @override
  String get quillAttrName => 'bold';
}
