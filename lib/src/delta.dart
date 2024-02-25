import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/painting.dart';

/// Provides methods related to bbcode format.
extension BBCodeDelta on Delta {
  /// Convert [Delta] into bbcode.
  String toBBCode() => whereType<TextInsert>().map((e) => e.toBBCode()).join();
}

/// Provides methods related to bbcode format.
///
/// About bbcode: https://en.wikipedia.org/wiki/BBCode
extension _BBCodeTextInsert on TextInsert {
  /// Convert the text info into a single bbcode node.
  String toBBCode() {
    final content = text;
    final tagsList = <(String, String?)?>[];
    attributes?.forEach((k, v) {
      tagsList.add(_parseAttribute(k, v));
    });
    var ret = content;
    for (final tag in tagsList.whereType<(String, String?)>()) {
      if (tag.$2 == null) {
        ret = '[${tag.$1}]$ret[/${tag.$1}]';
      } else {
        ret = '[${tag.$1}=${tag.$2}]$ret[/${tag.$1}]';
      }
    }
    return ret;
  }
}

(String k, String? v)? _parseAttribute(String name, dynamic value) {
  // TODO: Parse multiline quoted text.
  // TODO: Parse multiline code block.
  // TODO: Parse emoji.
  final label = switch (name) {
    'italic' when value == true => ('i', null),
    'bold' when value == true => ('b', null),
    'underline' when value == true => ('u', null),
    'strikethrough' when value == true => ('s', null),
    'font_color' => ('color', _formatColor(value)),
    'bg_color' => ('backcolor', _formatColor(value)),
    'href' => ('url', _prependHttpScheme('$value')),
    _ => null,
  };
  return label;
}

String _prependHttpScheme(String url) {
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url;
  }
  return 'https://$url';
}

String _formatColor(dynamic color) {
  final colorValue = int.tryParse(color as String);
  if (colorValue == null) {
    if (color.startsWith('0x')) {
      return '#${color.substring(2)}';
    }
    return color;
  } else {
    return Color(colorValue).toRgbaString();
  }
}
