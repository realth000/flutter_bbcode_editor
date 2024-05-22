import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';
import 'package:flutter_bbcode_editor/src/shortcuts/memtion_user.dart';

// /// Default callback when export data successfully.
// void _defaultExportCallback(BuildContext context, String exportPath) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(
//         'This document is saved to the $exportPath',
//       ),
//     ),
//   );
// }

/// Basic and common definition for bbcode editor.
class BasicEditor extends StatefulWidget {
  /// Constructor.
  const BasicEditor({
    required this.editorState,
    required this.emojiBuilder,
    required this.imageBuilder,
    this.urlLauncher,
    this.urlTextStyle,
    this.mentionUserLauncher,
    this.focusNode,
    this.autoFocus = false,
    this.controller,
    this.scrollController,
    super.key,
  });

  /// The state of editor.
  final EditorState editorState;

  /// Controller of editor.
  final BBCodeEditorController? controller;

  /// Scroller controller of the editor.
  final ScrollController? scrollController;

  final FocusNode? focusNode;

  final bool autoFocus;

  /////////////// Component Builder ///////////////

  final EmojiBuilder emojiBuilder;

  final ImageProvider Function(String url) imageBuilder;

  final UrlLauncher? urlLauncher;

  final TextStyle? urlTextStyle;

  final MentionUserLauncher? mentionUserLauncher;

  @override
  State<BasicEditor> createState() => BasicEditorState();
}

/// Basic and common definition for bbcode editor widget state.
class BasicEditorState extends State<BasicEditor> {
  // /// Import data from file path.
  // Future<void> importData(
  //   BBCodeFileType fileType,
  // ) async {
  //   final result = await FilePicker.platform.pickFiles(
  //     allowedExtensions: [fileType.extension],
  //     type: FileType.custom,
  //   );
  //   var plainText = '';
  //   if (!kIsWeb) {
  //     final path = result?.files.single.path;
  //     if (path == null) {
  //       return;
  //     }
  //     plainText = await File(path).readAsString();
  //   } else {
  //     final bytes = result?.files.first.bytes;
  //     if (bytes == null) {
  //       return;
  //     }
  //     plainText = const Utf8Decoder().convert(bytes);
  //   }

  //   var jsonString = '';
  //   switch (fileType) {
  //     case BBCodeFileType.documentJson:
  //       jsonString = plainText;
  //     case BBCodeFileType.markdown:
  //       jsonString = jsonEncode(markdownToDocument(plainText).toJson());
  //     case BBCodeFileType.delta:
  //       final delta = Delta.fromJson(jsonDecode(plainText) as List<dynamic>);
  //       final document = quillDeltaEncoder.convert(delta);
  //       jsonString = jsonEncode(document.toJson());
  //     case BBCodeFileType.html:
  //       throw UnimplementedError();
  //   }

  //   if (mounted) {
  //     setState(() {
  //       editorState.selectionService.clearSelection();
  //       editorState.selectionService.clearCursor();
  //       editorState.dispose();
  //       editorState = EditorState(
  //         document: Document.fromJson(
  //           jsonDecode(jsonString) as Map<String, dynamic>,
  //         ),
  //       );
  //     });
  //   }
  // }

  // /// Export the data in editor (by accessing [editorState]) as file type
  // /// [fileType] to some file.
  // ///
  // /// After export successfully, call [exportCallback].
  // Future<void> exportData(
  //   BBCodeFileType fileType,
  //   FutureOr<void> Function(BuildContext context, String exportPath)?
  //       exportCallback,
  // ) async {
  //   var result = '';

  //   switch (fileType) {
  //     case BBCodeFileType.documentJson:
  //       result = jsonEncode(editorState.document.toJson());
  //     case BBCodeFileType.markdown:
  //       result = documentToMarkdown(editorState.document);
  //     case BBCodeFileType.html:
  //     case BBCodeFileType.delta:
  //       throw UnimplementedError();
  //   }

  //   if (kIsWeb) {
  //     final blob = uh.Blob([result], 'text/plain', 'native');
  //     uh.AnchorElement(
  //       href: uh.Url.createObjectUrlFromBlob(blob),
  //     )
  //       ..setAttribute('download', 'document.${fileType.extension}')
  //       ..click();
  //   } else if (PlatformExtension.isMobile) {
  //     final appStorageDirectory = await getApplicationDocumentsDirectory();

  //     final path = File(
  //       '${appStorageDirectory.path}/${DateTime.now()}.${fileType.extension}',
  //     );
  //     await path.writeAsString(result);
  //     if (mounted) {
  //       exportCallback?.call(context, appStorageDirectory.path);
  //     }
  //   } else {
  //     // for desktop
  //     final path = await FilePicker.platform.saveFile(
  //       fileName: 'document.${fileType.extension}',
  //     );
  //     if (path != null) {
  //       await File(path).writeAsString(result);
  //       if (mounted) {
  //         exportCallback?.call(context, path);
  //       }
  //     }
  //   }
  // }

  @mustCallSuper
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
