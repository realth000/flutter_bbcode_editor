import 'package:appflowy_editor/appflowy_editor.dart';

/// BBCode parser class, parse raw bbcode into different formats.
class BBCodeParser {
  /// Parse raw bbcode text into quill document json format.
  ///
  /// Return null if [data] when encountered error.
  static Map<String, dynamic>? parseToJsonDocument(String data) {
    final root = Document.blank()
      ..insert([0], [paragraphNode(delta: Delta()..insert(data))]);
    return root.toJson();
  }
}
