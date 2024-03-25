import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/basic_editor.dart';
import 'package:flutter_bbcode_editor/src/shortcuts/emoji.dart';
import 'package:flutter_bbcode_editor/src/shortcuts/emoji_builder.dart';
import 'package:flutter_bbcode_editor/src/shortcuts/image.dart';
import 'package:flutter_bbcode_editor/src/shortcuts/url.dart';

extension BBCodeTextSpanDecorator on BasicEditor {
  /// This is the builder function to build inline bbcode components.
  ///
  /// Currently the appflowy-editor only provides [BlockComponentBuilder] which
  /// can render components but in **BLOCK**.
  ///
  /// Here is the provider for inline components, the rendered span will stay in
  /// the same line with around texts.
  ///
  /// Use for the following bbcode elements:
  ///
  /// * emoji
  /// * url
  /// * user mention (@).
  InlineSpan bbcodeInlineComponentBuilder(
    BuildContext context,
    Node node,
    int index,
    TextInsert text,
    TextSpan before,
    TextSpan after,
  ) {
    // Handle bbcode element here.
    // For the following bbcode element types, we want to make the element
    // inline with the around text, so BlockComponentBuilder is not
    // suitable.
    // Here we achieve the inline requirement by controlling how we render
    // the text span on text.
    // All bbcode element will have 'bbcode': Map<String,String> in
    // attributes:
    //
    // attributes: {
    //   'bbcode': {
    //     type: ${BBCODE_ELEMENT_TYPE},
    //     ...  <- different keys depend on different bbcode element types.
    //   }
    //   ...
    // }
    //
    final codeMap = text.attributes?['bbcode'] as Map?;
    if (codeMap == null) {
      return before;
    }
    final elementType = codeMap['type'] as String?;
    if (elementType == null) {
      return before;
    }
    final ret = switch (elementType) {
      EmojiBlocKeys.type when codeMap.hasEmoji => bbcodeInlineEmojiBuilder(
          emojiBuilder,
          codeMap[EmojiBlocKeys.code] as String,
        ),
      UrlBlockKeys.type when codeMap.hasUrl => bbcodeInlineUrlBuilder(
          context,
          codeMap[UrlBlockKeys.description] as String,
          codeMap[UrlBlockKeys.link] as String,
          urlLauncher,
        ),
      BBCodeImageBlockKeys.type when codeMap.hasImage =>
        bbcodeInlineImageBuilder(
          context,
          codeMap[BBCodeImageBlockKeys.link] as String,
          codeMap[BBCodeImageBlockKeys.width] as double,
          codeMap[BBCodeImageBlockKeys.height] as double,
          imageBuilder(codeMap[BBCodeImageBlockKeys.link] as String),
          defaultImageLoadingBuilder,
          defaultImageErrorBuilder,
        ),
      String() => before,
    };
    return ret;
  }
}
