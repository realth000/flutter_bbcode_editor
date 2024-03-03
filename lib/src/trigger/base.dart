import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/// Check [editorState] has [attrName] attribute or not.
///
/// This check runs on current selection in [editorState].
bool checkStateSelectionAttr(EditorState? editorState, String attrName) {
  if (editorState == null) {
    return false;
  }
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

/// Check the value of attribute [attrName] on current [editorState]'s
/// selection.
///
/// * When all nodes in have the same not-null value, return the only
/// same value.
/// * When all nodes have two or more not-null value, return null.
///
/// This is useful when we want to check and show some value attributes like
/// font color and background color. Only show the only one value if it is.
T? checkStateSelectionAttrValue<T>(EditorState? editorState, String attrName) {
  if (editorState == null) {
    return null;
  }
  final selection = editorState.selection?.normalized;
  if (selection == null) {
    return null;
  }

  final nodes = editorState.getNodesInSelection(selection).normalized;

  // The official api in appflowy-editor ignores collapsed selection, which
  // means when "user does not select anything", we can not get the attribute
  // in cursor position.
  //
  // For example, after these steps:
  //
  // 1. User entered "foo".
  // 2. User selected "foo" and set the font color to red.
  // 3. User tapped on the right side of "foo", so the cursor "looks like not
  //    selecting anything" where we call the selection is collapsed.
  //
  // All attributes are null in the cursor position as selection is collapsed.
  // This is wired because when the user continue to enter text after "foo", the
  // new entered text are still in red font color, but our tool bar will show a
  // null font color.
  //
  // The if statement here handles the situation above, when selection is
  // collapsed, find the delta contains cursor position and use it's attribute
  // state as the attribute we currently have.
  if (selection.isCollapsed) {
    // Here is the cursor position.
    final targetOffset = selection.start.offset;
    // Already checked length.
    var currentOffset = 0;
    for (final node in nodes) {
      final delta = node.delta;
      if (delta == null) {
        continue;
      }
      for (final op in delta.whereType<TextInsert>()) {
        currentOffset += op.text.length;
        if (currentOffset > targetOffset) {
          // The sum of all already walked offset is larger than target offset
          // Cursor is in current delta.
          return op.attributes?[attrName] as T?;
        }
      }
    }
    // Fallback.
    return null;
  }

  // Selection not collapsed.
  final allValueUsed = nodes
      .mapIndexed(
        (index, node) {
          Delta? delta;
          if (index == 0) {
            delta = node.delta?.slice(selection.start.offset);
          } else if (index == nodes.length - 1) {
            delta = node.delta?.slice(0, selection.end.offset);
          } else {
            delta = node.delta;
          }
          return delta
              ?.whereType<TextInsert>()
              .map((e) => e.attributes?[attrName] as T?)
              .toSet();
        },
      )
      .whereType<Set<T?>>()
      .flattened
      .toSet();
  debugPrint(
      '[BBCodeEditor] selection: $selection, collapsed:${selection.isCollapsed}');
  debugPrint('[BBCodeEditor] nodeLength: ${nodes.length} ${nodes.first}');
  debugPrint('[BBCodeEditor] check attr $attrName all values: $allValueUsed}');
  if (allValueUsed.isEmpty || allValueUsed.length > 1) {
    return null;
  } else {
    return allValueUsed.first;
  }
}

/// Toggle attribute [attrName] on current selection in [editorState].
Future<void> toggleStateSelectionAttr(
  EditorState? editorState,
  String attrName,
) async {
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