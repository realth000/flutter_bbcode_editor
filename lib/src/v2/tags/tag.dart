import 'package:flutter/cupertino.dart';

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

/// State of munching tag.
///
/// Provides information about current munching position with context.
///
/// This class is used as a state saver when parsing quill doc into bbcode.
/// Because there is no context support in raw quill doc but sometimes we need
/// it:
///
/// ```bbcode
/// [list]
/// [*]foo
/// [*]bar
/// [/list]
/// ```
///
/// Consider the bbcode above, the corresponding quill doc is:
///
/// ```json
/// [
///   {
///     "insert": "foo",
///     "attributes":  {
///       "list": "ordered"
///     }
///   },
///   {
///     "insert": "bar"
///   },
///   {
///     "insert": "\n",
///     "attributes":  {
///       "list": "ordered"
///     }
///   }
/// ]
/// ```
///
/// where when we parsing "bar" text, the info that we are inside an ordered
/// list or not.
///
/// Use this context to keep that info and parsing throughout the parsing
/// progress.
final class BBCodeTagContext {
  /// Flag indicating inside ordered list or not.
  ///
  /// ```bbcode
  /// [list=1]
  /// [*]foo
  /// [*]bar
  /// [/list]
  /// ```
  bool insideOrderedList = false;

  /// Flag indicating inside bullet list or not.
  ///
  /// ```bbcode
  /// [list]
  /// [*]foo
  /// [*]bar
  /// [/list]
  /// ```
  bool insideBulletList = false;
}
