import 'dart:typed_data';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';

/// All keys used in emoji node.
///
/// Static const strings.
class EmojiBlocKeys {
  const EmojiBlocKeys._();

  /// Type of the block.
  static const String type = 'emoji';

  /// Data here
  static const String code = 'code';
}

/// Provider that provide the emoji image from the given url.
///
/// Generally it's a http client but you can do validation and caching in
/// this function.
typedef EmojiProvider = Future<Uint8List> Function(String url);

/// Definition of an emoji in toolbar.
class Emoji {
  /// Constructor.
  const Emoji({
    required this.name,
    required this.code,
    required this.url,
  });

  /// Display name.
  final String name;

  /// Emoji bbcode.
  final String code;

  /// Url to fetch the emoji.
  final String url;
}

/// A group of emoji.
class EmojiGroup {
  /// Constructor.
  const EmojiGroup({
    required this.name,
    required this.emojiList,
  });

  /// Group name.
  final String name;

  /// All emoji in the group
  final List<Emoji> emojiList;
}

/// Emoji node in document.
Node emojiNode({
  required String code,
}) {
  return Node(type: EmojiBlocKeys.type, attributes: {
    EmojiBlocKeys.code: code,
  });
}

/// Provides emoji related method.
extension EmojiExtension on BBCodeEditorState {
  /// Insert emoji in current cursor position which represent like
  /// [code].
  Future<void> insertEmoji(String code) async {
    if (editorState == null) {
      return;
    }
    final selection = this.selection ?? lastUsedSelection;
    if (selection == null || !selection.isCollapsed) {
      return;
    }
    final node = editorState!.getNodeAtPath(selection.end.path);
    if (node == null) {
      return;
    }
    final transaction = editorState!.transaction;
    // if the current node is empty paragraph, replace it with image node
    if (node.type == ParagraphBlockKeys.type &&
        (node.delta?.isEmpty ?? false)) {
      transaction
        ..insertNode(
          node.path,
          emojiNode(code: code),
        )
        ..deleteNode(node);
    } else {
      transaction.insertNode(
        node.path.next,
        emojiNode(
          code: code,
        ),
      );
    }

    transaction.afterSelection = Selection.collapsed(
      Position(
        path: node.path.next,
        offset: 0,
      ),
    );

    return editorState!.apply(transaction);
  }

  /// Insert raw bbcode into editor.
  ///
  /// Only for components that do not support WYSIWYG.
  Future<void> insertRawCode(String code) async {
    if (editorState == null) {
      return;
    }
    final selection = this.selection ?? lastUsedSelection;
    // TODO: Support not collapsed selection.
    if (selection == null) {
      return;
    }
    final node = editorState!.getNodeAtPath(selection.end.path);
    if (node == null) {
      return;
    }
    // if the current node is empty paragraph, replace it with image node
    final transaction = editorState!.transaction
      ..insertText(
        node,
        selection.startIndex,
        code,
      )
      ..afterSelection = Selection.collapsed(
        Position(
          path: node.path,
          offset: selection.startIndex + code.length,
        ),
      );

    return editorState!.apply(transaction);
  }
}
