import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';

extension EditorBold on BBCodeEditorState {
  /// Check the current editor state and selection is in bold state.
  ///
  /// Useful when changing state.
  bool isBold() {
    final selection = editorState!.selection;
    if (selection == null) {
      return false;
    }
    final nodes = editorState!.getNodesInSelection(selection);
    // Old used to set the bold button style.
    final bool isSelected;
    // use `isCollapsed` to check whether selecting any text.
    if (selection.isCollapsed) {
      isSelected = editorState!.toggledStyle.containsKey(decorationNameBold);
    } else {
      isSelected = nodes.allSatisfyInSelection(
        selection,
        (delta) =>
            delta.everyAttributes((attr) => attr[decorationNameBold] == true),
      );
    }
    return isSelected;
  }

  /// Insert bold style into the editor.
  ///
  /// * When currently have some selected text, add bold tag around those text.
  /// * When no text is selected, add bold tag in the editor and move cursor
  ///   inside the tag.
  Future<void> triggerBold() async {
    if (editorState == null) {
      return;
    }
    final selection = editorState!.selection;
    if (selection == null) {
      return;
    }
    // Add or remove bold.
    setState(() {
      editorState!.toggleAttribute(decorationNameBold);
    });
  }
}
