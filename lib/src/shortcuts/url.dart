import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/shortcuts/emoji.dart';

/// Provided methods about url bbcode.
extension UrlBBCode on BBCodeEditorState {
  /// Insert raw bbcode [url], [text] is the display string.
  ///
  /// ```
  /// [url=${url}]${text}[/url]
  /// ```
  Future<void> insertRawUrl(String text, String url) async {
    if (text.startsWith('http://') || text.startsWith('https://')) {
      await insertRawCode('[url=$url]$text[/url]');
    } else {
      await insertRawCode('[url=$url]https://$text[/url]');
    }
  }
}
