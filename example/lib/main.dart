import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';

Future<void> main() async {
  await BBCodeEditor.initialize();
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
  late Future<String> _jsonString;

  @override
  void initState() {
    super.initState();

    _jsonString = Platform.isAndroid || Platform.isIOS
        ? rootBundle.loadString('assets/mobile_example.json')
        : rootBundle.loadString('assets/example.json');
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
                Text('Dark Mode'),
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
                  label: const Text('Import'),
                  icon: const Icon(Icons.file_upload),
                  onPressed: () {
                    controller.importData(BBCodeFileType.documentJson);
                  },
                ),
                TextButton.icon(
                  label: const Text('Export'),
                  icon: const Icon(Icons.file_download),
                  onPressed: () {
                    controller.exportData(BBCodeFileType.documentJson,
                        (context, exportPath) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'This document is saved to the $exportPath',
                          ),
                        ),
                      );
                    });
                  },
                ),
                TextButton.icon(
                  label: const Text('Convert To BBCode'),
                  icon: const Icon(Icons.code),
                  onPressed: () async {
                    await controller.convertToBBCode();
                  },
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: _jsonString,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  return BBCodeEditor(
                    controller: controller,
                    jsonString: snapshot.data!,
                    onEditorStateChange: (editorState) {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
