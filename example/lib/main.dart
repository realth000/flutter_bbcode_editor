import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BBCode Editor demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BBCode Editor Demo'),
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
              ],
            ),
            Expanded(
              child: BBCodeEditor(
                controller: controller,
                jsonString: _jsonString,
                onEditorStateChange: (editorState) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
