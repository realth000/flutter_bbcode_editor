import 'package:appflowy_editor/appflowy_editor.dart';

/// Provides methods related to bbcode format.
///
/// About bbcode: https://en.wikipedia.org/wiki/BBCode
extension BBCodeTextInsert on TextInsert {
  /// Convert the text info into a single bbcode node.
  String toBBCode() {
    final content = text;
    final tagsList = <String?>[];
    attributes?.forEach((k, v) {
      tagsList.add(_parseAttribute(k, v));
    });
    var ret = content;
    for (final tag in tagsList.whereType<String>()) {
      ret = '[$tag]$ret[/$tag]';
    }
    return ret;
  }
}

String? _parseAttribute(String name, dynamic value) {
  // TODO: Parse multiline quoted text.
  // TODO: Parse multiline code block.
  // TODO: Parse emoji.
  final label = switch (name) {
    'italic' => 'i',
    'bold' => 'b',
    'underline' => 'u',
    'strikethrough' => 's',
    'font_color' => 'color',
    'bg_color' => 'backcolor',
    'href' => 'url',
    _ => null,
  };
  return label;
}
