import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';

/// Code block.
///
/// ```bbcode
/// [code]$text[/code]
/// ```
final class CodeBlockTag extends BBCodeTag {
  /// Constructor.
  const CodeBlockTag();
  @override
  String get description => 'Code Block';

  @override
  String get quillAttrName => 'code-block';

  @override
  String get tagName => 'code';

  @override
  bool get isBlockTag => true;
}
