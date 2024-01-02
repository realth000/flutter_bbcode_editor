import 'package:flutter/material.dart';

import 'app_state.dart';
import 'app_state_manager.dart';
import 'basic_text_field.dart';
import 'formatting_toolbar.dart';
import 'replacements.dart';
import 'text_editing_delta_history_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BBCodeScopeWidget(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Simplistic Editor',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Simplistic Editor'),
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
  late BBCodeEditController _replacementTextEditingController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _replacementTextEditingController = BBCodeEditController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _replacementTextEditingController =
        BBCodeStateManager.of(context).bbcodeState.replacementsController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              const BBCodeToolbar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: BBCodeTextField(
                    controller: _replacementTextEditingController,
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                    focusNode: _focusNode,
                  ),
                ),
              ),
              const Expanded(
                child: BBCodeEditingDeltaHistoryView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
