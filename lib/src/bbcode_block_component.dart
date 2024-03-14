import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter_bbcode_editor/src/shortcuts/emoji.dart';
import 'package:flutter_bbcode_editor/src/shortcuts/emoji_builder.dart';

Map<String, BlockComponentBuilder> bbcodeBlockComponentBuilder({
  required EmojiBuilder emojiBuilder,
}) =>
    {
      EmojiBlocKeys.type: EmojiBlockComponentBuilder(
        configuration: standardBlockComponentConfiguration,
        emojiBuilder: emojiBuilder,
      ),
    };
