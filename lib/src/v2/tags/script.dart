import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';

// TODO: Handle both superscript and subscript.
/// Superscript or subscript.
///
/// Subscript not implemented yet.
///
/// Superscript
/// ```bbcode
/// [sup]$text[/sup]
/// ```
final class ScriptTag extends BBCodeTag {
  /// Constructor.
  const ScriptTag();

  @override
  String get description => 'Superscript';

  @override
  String get quillAttrName => 'script';

  @override
  String get tagName => 'sup';
}
