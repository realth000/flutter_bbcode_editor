import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/tags/spoiler/spoiler_embed.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Spoiler button in toolbar.
class BBCodeEditorToolbarSpoilerButton extends StatelessWidget {
  /// Constructor.
  const BBCodeEditorToolbarSpoilerButton({required this.controller, this.afterPressed, super.key});

  /// Injected editor controller.
  final BBCodeEditorController controller;

  /// Callback after button pressed.
  final void Function()? afterPressed;

  @override
  Widget build(BuildContext context) {
    return QuillToolbarIconButton(
      icon: const Icon(Icons.expand_circle_down_outlined),
      tooltip: context.bbcodeL10n.spoiler,
      iconTheme: const QuillIconTheme(),
      isSelected: false,
      onPressed: () async {
        if (Platform.isAndroid) {
          controller.insertRawCode('[spoiler=${context.bbcodeL10n.spoilerExpandOrCollapse}]', '[/spoiler]');
          return;
        }
        controller.insertEmbeddable(
          BBCodeSpoilerEmbed(BBCodeSpoilerInfo.buildEmpty(context.bbcodeL10n.spoilerExpandOrCollapse)),
        );
      },
      afterPressed: afterPressed,
    );
  }
}
