import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/desktop_editor.dart';
import 'package:flutter_bbcode_editor/src/file_type.dart';
import 'package:flutter_bbcode_editor/src/mobile_editor.dart';
import 'package:flutter_bbcode_editor/src/node.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as uh;

part 'editor_controller.dart';

/// The bbcode editor widget.
class BBCodeEditor extends StatefulWidget {
  /// Constructor.
  const BBCodeEditor({
    required this.jsonString,
    required this.onEditorStateChange,
    this.controller,
    this.editorStyle,
    super.key,
  });

  /// Controller of the editor.
  ///
  /// Offers accessibility with editor actions, developer can call those editor
  /// actions anywhere through the controller.
  final BBCodeEditorController? controller;

  /// Text data to display, is json format, [String] type.
  final Future<String> jsonString;

  /// The editor appearance.
  final EditorStyle? editorStyle;

  /// Callback called every time when editor state changes.
  final void Function(EditorState editorState) onEditorStateChange;

  @override
  State<BBCodeEditor> createState() => _BBCodeEditorState();
}

final class _BBCodeEditorState extends State<BBCodeEditor>
    with WidgetsBindingObserver {
  EditorState? editorState;
  bool initialized = false;

  Future<void> _traverse(
    Node node,
    List<String> contentStack,
    int contentLevel,
    FutureOr<void> Function(
      Node node,
      List<String> contentStack,
      int contentLevel,
    ) work,
  ) async {
    await work(node, contentStack, contentLevel);
    for (final ch in node.children) {
      await _traverse(ch, contentStack, contentLevel, work);
    }
  }

  Future<String?> convertToBBCode() async {
    if (editorState == null) {
      return null;
    }

    final contentStack = <String>[];
    final contentLevel = 0;

    final bbcodeState = BBCodeState();

    await _traverse(editorState!.document.root, contentStack, contentLevel, (
      node,
      contentStack,
      contentLevel,
    ) {
      // Note that because we only traverse the existing text content, only
      // `TextInsert` is expected to exist.
      final deltaContent = node.delta
          ?.map((op) {
            if (op is TextInsert) {
              return 'delta_text="${op.text}", delta_attr=${op.attributes}';
            }
            return null;
          })
          .whereType<String>()
          .join(', ');

      print('level=${node.level}, '
          'type=${node.type}, attr=${node.attributes}'
          '$deltaContent, ');

      contentStack.add(node.toBBCode(bbcodeState));
    });

    print('>>> result: ${contentStack.join('\n')}');

    return null;
  }

  /// Import data from file path.
  Future<void> importData(
    BBCodeFileType fileType,
  ) async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: [fileType.extension],
      type: FileType.custom,
    );
    var plainText = '';
    if (!kIsWeb) {
      final path = result?.files.single.path;
      if (path == null) {
        return;
      }
      plainText = await File(path).readAsString();
    } else {
      final bytes = result?.files.first.bytes;
      if (bytes == null) {
        return;
      }
      plainText = const Utf8Decoder().convert(bytes);
    }

    var jsonString = '';
    switch (fileType) {
      case BBCodeFileType.documentJson:
        jsonString = plainText;
      case BBCodeFileType.markdown:
        jsonString = jsonEncode(markdownToDocument(plainText).toJson());
      case BBCodeFileType.delta:
        final delta = Delta.fromJson(jsonDecode(plainText) as List<dynamic>);
        final document = quillDeltaEncoder.convert(delta);
        jsonString = jsonEncode(document.toJson());
      case BBCodeFileType.html:
        throw UnimplementedError();
    }

    if (mounted) {
      final completer = Completer<void>();
      editorState?.dispose();
      setState(() {
        editorState = EditorState(
          document: Document.fromJson(
            jsonDecode(jsonString) as Map<String, dynamic>,
          ),
        );
      });
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        completer.complete();
      });
      return completer.future;
    }
  }

  /// Export the data in editor (by accessing [editorState]) as file type
  /// [fileType] to some file.
  ///
  /// After export successfully, call [exportCallback].
  Future<void> exportData(
    BBCodeFileType fileType,
    FutureOr<void> Function(BuildContext context, String exportPath)?
        exportCallback,
  ) async {
    if (editorState == null) {
      return;
    }
    var result = '';

    switch (fileType) {
      case BBCodeFileType.documentJson:
        result = jsonEncode(editorState!.document.toJson());
      case BBCodeFileType.markdown:
        result = documentToMarkdown(editorState!.document);
      case BBCodeFileType.html:
      case BBCodeFileType.delta:
        throw UnimplementedError();
    }

    if (kIsWeb) {
      final blob = uh.Blob([result], 'text/plain', 'native');
      uh.AnchorElement(
        href: uh.Url.createObjectUrlFromBlob(blob),
      )
        ..setAttribute('download', 'document.${fileType.extension}')
        ..click();
    } else if (PlatformExtension.isMobile) {
      final appStorageDirectory = await getApplicationDocumentsDirectory();

      final path = File(
        '${appStorageDirectory.path}/${DateTime.now()}.${fileType.extension}',
      );
      await path.writeAsString(result);
      if (mounted) {
        exportCallback?.call(context, appStorageDirectory.path);
      }
    } else {
      // for desktop
      final path = await FilePicker.platform.saveFile(
        fileName: 'document.${fileType.extension}',
      );
      if (path != null) {
        await File(path).writeAsString(result);
        if (mounted) {
          exportCallback?.call(context, path);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._bind = this;
  }

  @override
  void dispose() {
    editorState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: widget.jsonString,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (!initialized) {
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
              controller: widget.controller,
            );
          } else if (PlatformExtension.isMobile) {
            return MobileEditor(
              editorState: editorState!,
              controller: widget.controller,
            );
          }
        }
        return Container();
      },
    );
  }
}
