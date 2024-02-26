import 'package:flutter_bbcode_editor/src/editor.dart';

/// Insert bold style into the editor.
///
/// * When currently have some selected text, add bold tag around those text.
/// * When no text is selected, add bold tag in the editor and move cursor
///   inside the tag.
Future<void> boldTrigger(BBCodeEditorState? editorState) async {
  if (editorState == null) {
    return;
  }
  final start = editorState.selection?.start;
  final end = editorState.selection?.end;
  print('>>> start=${start}, '
      'end=${end}');

  if (start == null || end == null) {
    return;
  }

  print(
      '>>> isSelecting: ${start.path[0] != end.path[0] || start.offset != end.offset}');
}
