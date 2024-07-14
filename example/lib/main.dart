import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_embeds.dart';

Future<void> main() async {
  // await BBCodeEditor.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

var themeMode = ValueNotifier(ThemeMode.light);

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, themeMode, child) => MaterialApp(
        themeMode: themeMode,
        title: 'BBCode Editor demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'BBCode Editor Demo'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = BBCodeEditorController();
  final _focusNode = FocusNode();
  late Future<String> _jsonString;

  final _quillController = QuillController.basic();
  final _quillFocusNode = FocusNode();

  void test() {
    _quillController.clear();
  }

  List<Widget> _buildQuill(BuildContext context) {
    return [
      QuillToolbar.simple(
        configurations: QuillSimpleToolbarConfigurations(
          controller: _quillController,
          embedButtons: FlutterQuillEmbeds.toolbarButtons(),
        ),
      ),
      Expanded(
        child: FutureBuilder(
          future: _jsonString,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return QuillEditor.basic(
              focusNode: _quillFocusNode,
              configurations: QuillEditorConfigurations(
                controller: _quillController,
                embedBuilders: kIsWeb
                    ? FlutterQuillEmbeds.editorWebBuilders()
                    : FlutterQuillEmbeds.editorBuilders(),
              ),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _buildEditor(BuildContext context) {
    return [
      BBCodeEditorToolbar(
        controller: controller,
        config: const BBCodeEditorToolbarConfiguration(
          fontFamilyValues: {
            'Arial': 'Arial',
          },
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            child: BBCodeEditor(
              controller: controller,
              focusNode: _focusNode,
            ),
          ),
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();

    _jsonString = Platform.isAndroid || Platform.isIOS
        ? rootBundle.loadString('assets/mobile_example.json')
        : rootBundle.loadString('assets/example.json');
  }

  @override
  void dispose() {
    _quillController.dispose();
    _quillFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                const Text('Dark Mode'),
                Switch(
                  value: themeMode.value == ThemeMode.dark,
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        themeMode.value = ThemeMode.dark;
                      } else {
                        themeMode.value = ThemeMode.light;
                      }
                    });
                  },
                )
              ],
            ),
            Row(
              children: [
                TextButton.icon(
                  label: const Text('Import Json'),
                  icon: const Icon(Icons.file_upload),
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles();

                    if (result == null) {
                      return;
                    }

                    final json =
                        await File(result.files.single.path!).readAsString();
                    final code = jsonDecode(json);
                    if (code is! List<dynamic>) {
                      debugPrint('invalid json data type: ${code.runtimeType}');
                      return;
                    }
                    controller.setDocumentFromJson(code);
                  },
                ),
                TextButton.icon(
                  label: const Text('Export Json'),
                  icon: const Icon(Icons.file_download),
                  onPressed: () async {
                    final json = controller.toJson();

                    final filePath = await FilePicker.platform.saveFile(
                      dialogTitle: 'Save content in json',
                      fileName: 'example.json',
                    );

                    if (filePath == null) {
                      return;
                    }

                    await File(filePath).writeAsString(json);
                  },
                ),
                TextButton.icon(
                  label: const Text('Convert To BBCode'),
                  icon: const Icon(Icons.code),
                  onPressed: () async {
                    final bbcode = controller.toBBCode();
                    debugPrint(bbcode);
                  },
                ),
              ],
            ),
            // ..._buildQuill(context),
            ..._buildEditor(context),
          ],
        ),
      ),
    );
  }
}
