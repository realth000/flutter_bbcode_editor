import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/shortcuts/emoji.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Function to launch a url when url tapped.
typedef UrlLauncher = Future<void> Function(String);

/// All document attributes keys used in url node.
///
/// Static const strings.
class UrlBlockKeys {
  const UrlBlockKeys._();

  /// Type of the block.
  static const String type = 'url';

  /// Data here
  static const String link = 'link';

  /// Description about this url.
  static const String description = 'description';
}

/// Internal function to build an url component [url] with [description] into an
/// inline span for the editor.
InlineSpan bbcodeInlineUrlBuilder(
  BuildContext context,
  String description,
  String url,
  UrlLauncher? urlLauncher,
  TextStyle? urlTextStyle,
) {
  return WidgetSpan(
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async =>
            urlLauncher?.call(url) ??
            launchUrlString(
              url,
              mode: LaunchMode.externalApplication,
            ),
        child: RichText(
          text: TextSpan(
            style: urlTextStyle ??
                TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  fontSize: defaultFontSize,
                ),
            children: [
              const WidgetSpan(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.link, size: defaultFontSize),
                    // Don't know why but add 4 more here makes widget almost
                    // same height with text.
                    SizedBox(width: 5, height: defaultFontSize + 4),
                  ],
                ),
              ),
              TextSpan(
                // Make text wrap inside words.
                text: description.split('').join('\u200B'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Provided methods about url bbcode.
extension UrlExtension on BBCodeEditorState {
  /// Insert [url] into editor, display [description].
  Future<void> insertUrl(String description, String url) async {
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
        'type': UrlBlockKeys.type,
        UrlBlockKeys.link: url,
        UrlBlockKeys.description: description,
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

  /// Insert raw bbcode [url], [text] is the display string.
  ///
  /// ```
  /// [url=${url}]${text}[/url]
  /// ```
  Future<void> insertRawUrl(String text, String url) async =>
      insertRawCode('[url=$url]$text[/url]');
}

extension CheckUrl on Map<dynamic, dynamic> {
  bool get hasUrl =>
      this[UrlBlockKeys.link] is String &&
      this[UrlBlockKeys.description] is String;
}

String? parseUrlData(Map<String, dynamic> data) {
  final link = data[UrlBlockKeys.link];
  final description = data[UrlBlockKeys.description];
  if (link == null || description == null) {
    return null;
  }
  return '[url=$link]$description[/url]';
}
