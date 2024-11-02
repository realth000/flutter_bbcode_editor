import 'package:flutter_bbcode_editor/src/tags/emoji/emoji_embed.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const code = 'some_code';

  test('with json', () {
    final target = BBCodeEmojiInfo(code: code);
    final json = target.toJson();
    final target2 = BBCodeEmojiInfo.fromJson(json);
    expect(target.code, code, reason: 'unexpected emoji code before json');
    expect(target2.code, code, reason: 'unexpected emoji code after json');
  });

  test('with bbcode', () {
    final embed = BBCodeEmojiEmbed(BBCodeEmojiInfo(code: code));
    final buffer = StringBuffer();
    BBCodeEmojiInfo.toBBCode(Embed(embed), buffer);
    final data = buffer.toString();
    expect(data, code, reason: 'unexpected emoji bbcode format');
  });
}
