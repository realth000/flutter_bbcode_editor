import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';

/// Function to call when tap on the mention user span.
typedef MentionUserLauncher = Future<void> Function(String);

/// All document attributes keys used in url node.
///
/// Static const strings.
class MentionUserKeys {
  const MentionUserKeys._();

  /// Type of the block.
  static const String type = 'mention';

  /// Username of the user to mention.
  static const String username = 'username';
}

InlineSpan bbcodeInlineMentionUserBuilder(
  BuildContext context,
  String username,
  MentionUserLauncher? mentionUserLauncher,
) {
  return WidgetSpan(
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async => mentionUserLauncher?.call(username),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            children: [
              const WidgetSpan(
                child: Icon(
                  Icons.alternate_email_outlined,
                  size: 23,
                ),
              ),
              const WidgetSpan(child: SizedBox(width: 5, height: 23)),
              WidgetSpan(
                child: Text(
                  username,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

extension MentionUserExtention on BBCodeEditorState {
  Future<void> insertMentionUser(String username) async {
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

    final attr = {
      'bbcode': {
        'type': MentionUserKeys.type,
        MentionUserKeys.username: username,
      },
    };

    if (node.type == ParagraphBlockKeys.type &&
        (node.delta?.isEmpty ?? false)) {
      // TODO: Handle selection is expanded.
      transaction.insertText(
        node,
        selection.endIndex,
        r'$',
        attributes: attr,
      );
    } else {
      transaction.insertText(
        node,
        selection.endIndex,
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
}

extension CheckMentionUser on Map<dynamic, dynamic> {
  bool get hasMentionUser => this[MentionUserKeys.username] is String;
}

String? parseMentionUserData(Map<dynamic, dynamic> data) {
  final username = data[MentionUserKeys.username];
  if (username == null) {
    return null;
  }
  return '[@]$username[/@]';
}
