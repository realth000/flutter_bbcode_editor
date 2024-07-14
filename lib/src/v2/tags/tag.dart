import 'package:flutter/cupertino.dart';
import 'package:flutter_bbcode_editor/src/v2/context.dart';

/// BBCode tag interface.
///
/// Describe what a bbcode tag should do.
///
/// A BBCode tag generally looks like:
///
/// ```bbcode
/// [$HEAD=$ATTR]$TEXT[/$TAIL]
/// ```
///
/// * HEAD: Tag head, also the identifier for an unique bbcode tag type.
/// * ATTR: Optional text string, some tags may have attributes:
///   * [url=xxx.com]text to display[/url].
///   * [img=img_width,img_height]url_to_image[/img].
///   * Can be a regular expression that check and grab values from text.
/// * TEXT: Text warped by current bbcode tag.
/// * TAIL: Tag tail, always the same with HEAD.
@immutable
abstract class BBCodeTag {
  /// Default const constructor.
  const BBCodeTag();

  /// Tag description.
  ///
  /// What this tag does or looks like.
  String get description;

  /// Attribute name used in quill.
  String get quillAttrName;

  /// Tag name.
  ///
  /// Use to identify a tag.
  String get tagName;

  /// Whether the tag is "block", not "inline".
  ///
  /// Block tags MUST stay in a or more standalone rows, can not have text with
  /// them in the same row.
  ///
  /// e.g. "code block" and "quote block" are blocks.
  bool get isBlockTag => false;

  /// If current text position is inside a block, optional transform step on
  /// current text.
  ///
  /// Only works when [isBlockTag] is true.
  ///
  /// For example:
  ///
  /// Ordered list is "block" tag:
  ///
  /// ```bbcode
  /// [list=1]
  /// [*]foo
  /// [*]bar
  /// [/list]
  /// ```
  ///
  /// Every item inside the list start with `[*]`, so the [inBlockTransformer]
  /// for ordered block is:
  ///
  /// ```dart
  /// @override
  /// String inBlockTransformer(String text) => "[*]text";
  /// ```
  String inBlockTransformer(String text) => text;

  /// Validate the attribute string.
  ///
  /// If is invalid attribute, return false so that the parsing progress can
  /// terminate or fallback to plain text.
  bool validateAttribute(String attr) => true;

  /// Add raw bbcode tag around current text.
  ///
  /// Where [text] is the content text and [attribute] is the optional string
  /// after side.
  String toBBCode(String text, dynamic attribute) =>
      '[$tagName]$text[/$tagName]';

  /// Only prepend tag head to [text].
  String prependBBCodeHead(String text) => '[$tagName]$text';

  /// Only append tag tail to [text].
  String appendBBCodeTail(String text) => '$text[/$tagName]';

  /// Transform [text] according to current parsing [context].
  String handleContext(String text, BBCodeTagContext context) {
    if (context.insideOrderedList) {
      return '[*]$text';
    }

    return text;
  }

  @override
  bool operator ==(Object other) =>
      other is BBCodeTag && tagName == other.tagName;

  @override
  int get hashCode => Object.hashAll([tagName]);
}
