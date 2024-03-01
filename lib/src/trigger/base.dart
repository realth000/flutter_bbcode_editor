import 'package:appflowy_editor/appflowy_editor.dart';

/// Check [editorState] has [attrName] attribute or not.
///
/// This check runs on current selection in [editorState].
bool checkStateSelectionAttr(EditorState editorState, String attrName) {
  final selection = editorState.selection;
  if (selection == null) {
    return false;
  }
  final nodes = editorState.getNodesInSelection(selection);
  // Old used to set the bold button style.
  final bool isSelected;
  // use `isCollapsed` to check whether selecting any text.
  if (selection.isCollapsed) {
    isSelected = editorState.toggledStyle[attrName] ?? false;
  } else {
    isSelected = nodes.allSatisfyInSelection(
      selection,
      (delta) => delta.everyAttributes((attr) => attr[attrName] == true),
    );
  }
  return isSelected;
}

/// Toggle attribute [attrName] on current selection in [editorState].
Future<void> toggleStateSelectionAttr(
    EditorState? editorState, String attrName) async {
  if (editorState == null) {
    return;
  }
  final selection = editorState.selection;
  if (selection == null) {
    return;
  }
  // Add or remove bold.
  await editorState.toggleAttribute(
    attrName,
    selectionExtraInfo: {
      selectionExtraInfoDoNotAttachTextService: true,
    },
  );
}
