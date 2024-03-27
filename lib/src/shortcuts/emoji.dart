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
    //
    // Here we archive inline emoji by adding attributes to text node.
    // All the bbcode inline elements are having a map value with key 'bbcode'.
    // And in that map, 'type' key indicates the bbcode element type (emoji,
    // url, image, mention user, ...).
    final attr = {
      'bbcode': {
        'type': EmojiBlocKeys.type,
        EmojiBlocKeys.code: code,
      },
    };
    if (node.type == ParagraphBlockKeys.type &&
        (node.delta?.isEmpty ?? false)) {
      // TODO: Handle selection is expanded.
      transaction.insertText(
        node,
        selection.startIndex,
        r'$',
        attributes: attr,
      );
    } else {
      transaction.insertText(
        node,
        selection.startIndex,
        r'$',
        attributes: attr,
      );
    }

    transaction.afterSelection = Selection.collapsed(
      Position(
        path: node.path,
        offset: selection.endIndex + 1,
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

extension CheckEmoji on Map<dynamic, dynamic> {
  bool get hasEmoji => this[EmojiBlocKeys.code] is String;
}

String? parseEmojiData(Map<String, dynamic> data) {
  final code = data[EmojiBlocKeys.code];
  if (code == null) {
    return null;
  }
  return '$code';
}
