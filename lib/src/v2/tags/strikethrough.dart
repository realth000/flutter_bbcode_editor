import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';

/// Strikethrough text.
///
/// ```bbcode
/// [s]$text[/s]
/// ```
final class StrikethroughTag extends BBCodeTag {
  /// Constructor.
  const StrikethroughTag();

  @override
  String get description => 'Strikethrough Text';

  @override
  String get quillAttrName => 'strike';

  @override
  String get tagName => 's';
}
