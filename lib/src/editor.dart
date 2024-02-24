import 'dart:convert';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/desktop_editor.dart';
import 'package:flutter_bbcode_editor/src/mobile_editor.dart';

/// The bbcode editor widget.
class Editor extends StatefulWidget {
  /// Constructor.
  const Editor({
    required this.jsonString,
    required this.onEditorStateChange,
    this.editorStyle,
    super.key,
  });

  /// Text data to display, is json format, [String] type.
  final Future<String> jsonString;

  /// The editor appearance.
  final EditorStyle? editorStyle;

  /// Callback called every time when editor state changes.
  final void Function(EditorState editorState) onEditorStateChange;

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  EditorState? editorState;
  bool initialized = false;

  @override
  void dispose() {
    editorState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<String>(
          future: widget.jsonString,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (!initialized || editorState == null) {
                initialized = true;
                final editorState = EditorState(
                  document: Document.fromJson(
                    jsonDecode(snapshot.data!) as Map<String, dynamic>,
                  ),
                );

                editorState.logConfiguration
                  ..handler = debugPrint
                  ..level = LogLevel.off;

                editorState.transactionStream.listen((event) {
                  if (event.$1 == TransactionTime.after) {
                    // Call editor state change callback after state changed.
                    widget.onEditorStateChange(editorState);
                  }
                });

                this.editorState = editorState;
              }

              if (PlatformExtension.isDesktopOrWeb) {
                return DesktopEditor(
                  editorState: editorState!,
                  themeData: Theme.of(context),
                );
              } else if (PlatformExtension.isMobile) {
                return MobileEditor(
                  editorState: editorState!,
                  themeData: Theme.of(context),
                );
              }
            }
            return Container();
          },
        ),
      ],
    );
  }
}
