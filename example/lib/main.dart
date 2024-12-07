import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';

// Dialog to pick a emoji.
Future<String?> _emojiPicker(BuildContext context) {
  return showModalBottomSheet<String>(
      context: context,
      builder: (_) => Center(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 30,
                mainAxisExtent: 30,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              children: [
                Icons.add,
                Icons.remove,
                Icons.arrow_left,
                Icons.arrow_upward,
                Icons.arrow_right,
                Icons.arrow_downward,
              ]
                  .map(
                    (e) => GestureDetector(
                        onTap: () {
                          // Here returns the emoji bbcode.
                          // Every forum may have different styles:
                          //
                          // * {$code}
                          // * [emoji=$code]
                          // * ...
                          //
                          // Here assumes format as [emoji=$code].
                          // Keep the same process when converting emoji code
                          // to emoji image then everything is ok.
                          Navigator.of(context)
                              .pop('[emoji=${Icons.add.codePoint}]');
                        },
                        child: CircleAvatar(child: Icon(e))),
                  )
                  .toList(),
            ),
          ));
}

Future<PickUrlResult?> _urlPicker(
  BuildContext context,
  String? url,
  String? description,
) async {
  final urlController = TextEditingController(text: url ?? '');
  final descController = TextEditingController(text: description);
  final result = await showDialog<PickUrlResult>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  icon: Icon(Icons.link),
                ),
                autofocus: true,
                controller: urlController,
              ),
              TextField(
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  icon: Icon(Icons.description),
                ),
                controller: descController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(PickUrlResult(
                  url: urlController.text,
                  description: descController.text,
                ));
              },
              child: const Text('Submit'),
            )
          ],
        );
      });

  urlController.dispose();
  descController.dispose();
  return result;
}

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
  final controller = buildBBCodeEditorController();
  final _focusNode = FocusNode();
  late Future<String> _jsonString;

  List<Widget> _buildEditor(BuildContext context) {
    return [
      BBCodeEditorToolbar(
        controller: controller,
        config: const BBCodeEditorToolbarConfiguration(
          fontFamilyValues: {
            'Arial': 'Arial',
          },
        ),
        emojiPicker: (context) async => _emojiPicker(context),
        urlPicker: (context, url, desc) async => _urlPicker(context, url, desc),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: InputDecorator(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            child: BBCodeEditor(
              emojiPicker: (_) {
                throw UnimplementedError();
              },
              controller: controller,
              focusNode: _focusNode,
              autoFocus: true,
              emojiProvider: (context, code) {
                // Assume emoji code format is [emoji=].
                // Keep the same format with what we define in emojiPicker.
                final codeValue = int.parse(
                    code.replaceFirst('[emoji=', '').replaceFirst(']', ''));

                if (codeValue == Icons.add.codePoint) {
                  return const Icon(Icons.add);
                } else if (codeValue == Icons.remove.codePoint) {
                  return const Icon(Icons.remove);
                } else if (codeValue == Icons.arrow_left.codePoint) {
                  return const Icon(Icons.arrow_left);
                } else if (codeValue == Icons.arrow_upward.codePoint) {
                  return const Icon(Icons.arrow_upward);
                } else if (codeValue == Icons.arrow_right.codePoint) {
                  return const Icon(Icons.arrow_right);
                } else if (codeValue == Icons.arrow_downward.codePoint) {
                  return const Icon(Icons.arrow_downward);
                } else {
                  throw UnimplementedError();
                }
              },
              userMentionHandler: (username) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Called $username'),
                ));
              },
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
            ..._buildEditor(context),
          ],
        ),
      ),
    );
  }
}
