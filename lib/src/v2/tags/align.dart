import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';

/// Align tag interface
sealed class AlignTag extends BBCodeTag {
  /// Constructor.
  const AlignTag();

  @override
  String get quillAttrName => 'align';

  @override
  String get tagName => 'align';

  @override
  bool get isBlockTag => true;

  @override
  String toBBCode(String text, dynamic attribute) {
    print('>>>>> with or without sign ${attribute.runtimeType}');
    if (attribute is String) {
      print('>>>>> with sign');
      return '[$tagName=$attribute]$text[/$tagName]';
    }
    print('>>>>> without sign');
    return super.toBBCode(text, attribute);
  }
}

/// Align left
///
/// ```bbcode
/// [align=left]$text[/align]
/// ```
final class AlignLeftTag extends AlignTag {
  /// Constructor.
  const AlignLeftTag();

  @override
  String get description => 'Align Left';

  @override
  bool validateAttribute(dynamic attr) => attr is String && attr == 'left';

  @override
  String prependBBCodeHead(String text) => '[$tagName=left]$text';
}

/// Align center
///
/// ```bbcode
/// [align=center]$text[/align]
/// ```
final class AlignCenterTag extends AlignTag {
  /// Constructor.
  const AlignCenterTag();

  @override
  String get description => 'Align Center';

  @override
  bool validateAttribute(dynamic attr) => attr is String && attr == 'center';

  @override
  String prependBBCodeHead(String text) => '[$tagName=center]$text';
}

/// Align right
///
/// ```bbcode
/// [align=right]$text[/align]
/// ```
final class AlignRightTag extends AlignTag {
  /// Constructor.
  const AlignRightTag();

  @override
  String get description => 'Align Right';

  @override
  bool validateAttribute(dynamic attr) => attr is String && attr == 'right';

  @override
  String prependBBCodeHead(String text) => '[$tagName=right]$text';
}
