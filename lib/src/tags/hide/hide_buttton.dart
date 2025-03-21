import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/tags/hide/hide_embed.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Hide button in toolbar.
class BBCodeEditorToolbarHideButton extends StatelessWidget {
  /// Constructor.
  const BBCodeEditorToolbarHideButton({required this.controller, super.key});

  /// Injected editor controller.
  final BBCodeEditorController controller;

  @override
  Widget build(BuildContext context) {
    return QuillToolbarIconButton(
      icon: const Icon(Icons.visibility_off_outlined),
      tooltip: context.bbcodeL10n.hide,
      iconTheme: const QuillIconTheme(),
      isSelected: false,
      onPressed: () async {
        if (Platform.isAndroid) {
          controller.insertRawCode('[hide]', '[/hide]');
          return;
        }
        controller.insertEmbeddable(BBCodeHideEmbed(BBCodeHideInfo.buildEmpty()));
      },
    );
  }
}
