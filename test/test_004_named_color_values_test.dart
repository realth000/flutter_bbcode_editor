import 'package:collection/collection.dart';
import 'package:dart_bbcode_web_colors/dart_bbcode_web_colors.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('values synced with dart_bbcode_web_colors', () {
    // All colors in `BBCodeEditorColor` shall have the same value with the one in `WebColors`.
    for (final color in BBCodeEditorColor.values) {
      final target = WebColors.values.firstWhereOrNull(
        (e) => e.colorValue == color.color.toARGB32() && e.name.toLowerCase() == color.namedColor.toLowerCase(),
      );
      expect(target != null, true, reason: 'BBCodeEditorColor "$color" not synced');
    }
  });
}
