import 'package:flutter_bbcode_editor/src/tags/user_mention/user_mention_embed.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const username = 'some_name';

  test('with json', () {
    const target = BBCodeUserMentionInfo(username: username);
    final json = target.toJson();
    final target2 = BBCodeUserMentionInfo.fromJson(json);
    expect(
      target.username,
      username,
      reason: 'unexpected user mention code before json',
    );
    expect(
      target2.username,
      username,
      reason: 'unexpected user mention code after json',
    );
  });

  test('with bbcode', () {
    final embed = BBCodeUserMentionEmbed(
      const BBCodeUserMentionInfo(
        username: username,
      ),
    );
    final buffer = StringBuffer();
    BBCodeUserMentionInfo.toBBCode(Embed(embed), buffer);
    final data = buffer.toString();
    expect(
      data,
      '[@]$username[/@]',
      reason: 'unexpected user mention bbcode format',
    );
  });
}
