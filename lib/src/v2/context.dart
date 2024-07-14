import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';

/// State of munching tag.
///
/// **ONLY used in parsing quill delta into bbcode.**
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
///
/// ## What this context does
///
/// When parsing quill delta into bbcode, there are so many situations that the
/// json format delta is NOT finally what text looks like which after rendering:
///
/// ```json
/// [
///   {
///     "insert": "start\ncode_foo"
///   },
///   {
///     "insert": "bar",
///     "attributes": {
///       "bold": true
///     }
///   },
///   {
///     "insert": "\n",
///     "attributes": {
///       "blockquote": true
///     }
///   },
///   {
///     "insert": "end\n"
///   }
/// ]
/// ```
///
/// The above delta is rendered into:
///
/// 1. Paragraph "start"
/// 2. Code block "code_foobar" where "foo" is bold.
/// 3. Paragraph "end"
///
/// "code_foo" is also in the block, not likely at first glance.
///
/// So in the parsing process, we have to take care of "BLOCK" type formats,
/// move some text outside the operation into it.
///
/// For example, parse the above delta:
///
/// 1. Scan delta reversely, which means from the last operation to the first
///   operation, so that we can know what "BLOCK" type format we are in before
///   munched all text "should" in it.
/// 2. When parsing the operation contains attribute "blockquote", mark that we
///   are inside a quote block.
/// 3. When parsing the first operation, chop the tail text after "\n" and
///   prepend them inside "blockquote" then close "blockquote".
final class BBCodeTagContext {
  /// Use this [Set] of [String] to record all block tag we are in.
  ///
  /// Block tag is a type of bbcode tag that:
  /// * Can have multiple lines of text
  /// * Can NOT have other tags in the same row. They consume the entire row.
  ///
  /// e.g.
  ///
  /// Code block:
  ///
  /// ```bbcode
  /// [code]first line
  /// second line[/code]
  /// ```
  ///
  /// Quote block:
  ///
  /// ```bbcode
  /// [quote]first line
  /// second line[/quote]
  /// ```
  ///
  /// When parsing delta, we need to remember what kinds of block tag we are in,
  /// and when enter/leave the block tag, prepend/append tag header/tail around
  /// text content. Because in quill data only the tail node has a attribute of
  /// that block tag:
  ///
  /// ```json
  /// [
  ///   {
  ///     "insert": "start\nquote_foo"
  ///   },
  ///   {
  ///     "insert": "bar",
  ///     "attributes": {
  ///       "bold": true
  ///     }
  ///   },
  ///   {
  ///     "insert": "\n",
  ///     "attributes": {
  ///       "blockquote": true
  ///     }
  ///   },
  ///   {
  ///     "insert": "end\n"
  ///   }
  /// ]
  /// ```
  ///
  /// Parse operations from last one to first one.
  ///
  /// 1. When parsing the 3rd operation, push a flag indicating "we are now
  ///   inside "quote block" into [insideBlockTagSet].
  /// 2. When parsing the 2nd operation, text "bar" does not contain "\n" so it
  ///    is entirely inside "quote block".
  /// 3. When parsing the 1st operation, text "start\nquote_foo" has "\n", so
  ///    the text after the last "\n" in text is also inside "quote block".
  ///
  /// Append and prepend `[/quote]`/`[quote]` in step 3 and 1.
  List<BBCodeTag> insideBlockTagSet = [];

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
