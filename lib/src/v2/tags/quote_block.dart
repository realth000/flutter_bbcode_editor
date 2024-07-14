import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';

/// Quoted block.
///
/// ```bbcode
/// [quote]$text[/quote].
/// ```
final class QuoteBlockTag extends BBCodeTag {
  /// Constructor.
  const QuoteBlockTag();

  @override
  String get description => 'Quote Block';

  @override
  String get quillAttrName => 'blockquote';

  @override
  String get tagName => 'quote';

  @override
  bool get isBlockTag => true;
}
