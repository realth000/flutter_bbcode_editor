import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/desktop_editor.dart';
import 'package:flutter_bbcode_editor/src/file_type.dart';
import 'package:flutter_bbcode_editor/src/mobile_editor.dart';
import 'package:flutter_bbcode_editor/src/node.dart';
import 'package:flutter_bbcode_editor/src/parser/parser.dart';
import 'package:flutter_bbcode_editor/src/shortcuts/emoji.dart';
import 'package:flutter_bbcode_editor/src/shortcuts/emoji_builder.dart';
import 'package:flutter_bbcode_editor/src/shortcuts/image.dart';
import 'package:flutter_bbcode_editor/src/shortcuts/url.dart';
import 'package:flutter_bbcode_editor/src/trigger/background_color.dart';
import 'package:flutter_bbcode_editor/src/trigger/bold.dart';
import 'package:flutter_bbcode_editor/src/trigger/font_size.dart';
import 'package:flutter_bbcode_editor/src/trigger/foreground_color.dart';
import 'package:flutter_bbcode_editor/src/trigger/italic.dart';
import 'package:flutter_bbcode_editor/src/trigger/strikethrough.dart';
import 'package:flutter_bbcode_editor/src/trigger/underline.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_html/html.dart' as uh;

part 'editor_controller.dart';
part 'editor_value.dart';

/// The bbcode editor widget.
class BBCodeEditor extends StatefulWidget {
  /// Constructor.
  BBCodeEditor({
    required this.emojiBuilder,
    required this.imageBuilder,
    this.urlLauncher,
    this.jsonString,
    this.controller,
    this.editorStyle,
    this.onEditorStateChange,
    this.focusNode,
    this.autoFocus = false,
    super.key,
  }) : assert(
          BBCodeEditor._initialized,
          'Must call await BBCodeEditor.initialize() before using the editor',
        );

  static bool _initialized = false;

  /// Initialize the editor.
  ///
  /// Call this once before using [BBCodeEditor].
  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    // According to https://github.com/AppFlowy-IO/appflowy-editor/issues/637#issuecomment-1873187057
    AppFlowyRichTextKeys.supportToggled.add(AppFlowyRichTextKeys.fontSize);
    _initialized = true;
  }

  /// Controller of the editor.
  ///
  /// Offers accessibility with editor actions, developer can call those editor
  /// actions anywhere through the controller.
  final BBCodeEditorController? controller;

  /// Text data to display, is json format, [String] type.
  final String? jsonString;

  /// The editor appearance.
  final EditorStyle? editorStyle;

  /// Callback called every time when editor state changes.
  final void Function(EditorState editorState)? onEditorStateChange;

  /// Focus node on the editor.
  final FocusNode? focusNode;

  /// Auto focus when changed.
  final bool autoFocus;

  ////////////////// Component Builder //////////////////

  /// Build emoji from bbcode.
  ///
  /// Return image data if code is valid.
  /// Return null if code is invalid.
  final EmojiBuilder emojiBuilder;

  /// Function to launch url when url tapped.
  ///
  /// Use package url_launcher if not set.
  final UrlLauncher? urlLauncher;

  /// Provide image.
  final ImageProvider Function(String url) imageBuilder;

  @override
  State<BBCodeEditor> createState() => BBCodeEditorState();
}

/// The state of editor.
final class BBCodeEditorState extends State<BBCodeEditor>
    with WidgetsBindingObserver {
  /// True editor state.
  EditorState? editorState;

  /// Get the selection of editor.
  Selection? get selection => editorState?.selection;

  /// In many situations we lost focus when asking the user to insert some
  /// data, for example choose an emoji. But right after the choice we want
  /// to insert the data (if any) and restore the focus.
  ///
  /// This can't be reached without recording the last used selection because
  /// we lost focus and do not know where to insert data and restore focus.
  ///
  /// Maybe we should use quill instead of AppFlowy Editor.
  Selection? _lastUsedSelection;

  /// Return the last used not-null selection.
  ///
  /// Return null when no selection used before.
  Selection? get lastUsedSelection => _lastUsedSelection;

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

  /// Convert the data in editor into bbcode format.
  Future<String?> convertToBBCode() async {
    if (editorState == null) {
      return null;
    }

    final contentStack = <String>[];
    final contentLevel = 0;

    final bbcodeState = BBCodeState.empty();

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

  bool isEmpty() {
    return editorState?.document.isEmpty ?? true;
  }

  String? plainData() {
    return editorState?.document.root.toBBCode(BBCodeState.empty());
  }

  void onSelectionChanged() {
    if (editorState?.selection != null) {
      // Only record the last used not-null selection.
      _lastUsedSelection = editorState?.selection;
    }
    setState(() {
      widget.controller?._update();
    });
    widget.controller?.onSelectionChanged?.call();
  }

  @override
  void initState() {
    super.initState();
    final Document doc;
    if (widget.controller?.data == null) {
      doc = Document.blank();
    } else {
      final d = BBCodeParser.parseToJsonDocument(widget.controller!.data!);
      if (d == null) {
        doc = Document.blank();
      } else {
        doc = Document.fromJson(d);
      }
    }

    final editorState = EditorState(document: doc);

    editorState.logConfiguration
      ..handler = debugPrint
      ..level = LogLevel.off;

    editorState.transactionStream.listen((event) {
      if (event.$1 == TransactionTime.after) {
        // Call editor state change callback after state changed.
        widget.onEditorStateChange?.call(editorState);
      }
    });
    this.editorState = editorState;

    widget.controller?._bind = this;
    editorState.selectionNotifier.addListener(onSelectionChanged);
  }

  @override
  void dispose() {
    editorState?.selectionNotifier.removeListener(onSelectionChanged);
    editorState?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (PlatformExtension.isDesktopOrWeb) {
      return DesktopEditor(
        editorState: editorState!,
        emojiBuilder: widget.emojiBuilder,
        imageBuilder: widget.imageBuilder,
        urlLauncher: widget.urlLauncher,
        controller: widget.controller,
        focusNode: widget.focusNode,
      );
    } else if (PlatformExtension.isMobile) {
      return MobileEditor(
        editorState: editorState!,
        emojiBuilder: widget.emojiBuilder,
        imageBuilder: widget.imageBuilder,
        urlLauncher: widget.urlLauncher,
        controller: widget.controller,
        focusNode: widget.focusNode,
      );
    }
    return Container();
  }
}
