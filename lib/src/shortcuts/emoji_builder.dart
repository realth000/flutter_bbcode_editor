import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Function that build a emoji [code] into emoji image data.
///
/// Use the text when return null (considered as invalid emoji [code]).
///
/// Users should define this if they want to use emoji.
typedef EmojiBuilder = Future<Uint8List?> Function(String code);

/// Internal function to build an emoji [code] with [emojiBuilder] into an
/// inline span for the editor.
InlineSpan bbcodeInlineEmojiBuilder(EmojiBuilder emojiBuilder, String code) {
  return WidgetSpan(
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: SizedBox(
          width: 40,
          height: 40,
          child: FutureBuilder(
            future: emojiBuilder(code),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                return Image.memory(data);
              }
              return Text(code);
            },
          ),
        ),
      ),
    ),
  );
}
