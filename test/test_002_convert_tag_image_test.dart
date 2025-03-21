import 'package:flutter_bbcode_editor/src/tags/image/image_embed.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const link = 'some_link';
  const width = 1234;
  const height = 5678;

  test('with json', () {
    const target = BBCodeImageInfo(link);
    final json = target.toJson();
    final target2 = BBCodeImageInfo.fromJson(json);
    expect(target.link, link, reason: 'unexpected image code before json');
    expect(target2.link, link, reason: 'unexpected image code after json');
  });

  test('with bbcode', () {
    final embed = BBCodeImageEmbed(const BBCodeImageInfo(link));
    final buffer = StringBuffer();
    BBCodeImageInfo.toBBCode(Embed(embed), buffer);
    final data = buffer.toString();
    expect(data, '[img]$link[/img]', reason: 'unexpected image format');
  });

  test('with json, size', () {
    const target = BBCodeImageInfo(link, width: width, height: height);
    final json = target.toJson();
    final target2 = BBCodeImageInfo.fromJson(json);
    expect(target.link, link, reason: 'unexpected image link before json');
    expect(target.width, width, reason: 'unexpected image width before json');
    expect(target.height, height, reason: 'unexpected image height before json');
    expect(target2.link, link, reason: 'unexpected image link after json');
    expect(target2.width, width, reason: 'unexpected image width after json');
    expect(target2.height, height, reason: 'unexpected image height after json');
  });

  test('with bbcode, size', () {
    final embed = BBCodeImageEmbed(const BBCodeImageInfo(link, width: width, height: height));
    final buffer = StringBuffer();
    BBCodeImageInfo.toBBCode(Embed(embed), buffer);
    final data = buffer.toString();
    expect(data, '[img=$width,$height]$link[/img]', reason: 'unexpected image format');
  });
}
