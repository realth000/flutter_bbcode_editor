import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/tags/divider/divider_embed.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Divider button in toolbar.
class BBCodeEditorToolbarDividerButton extends StatelessWidget {
  /// Constructor.
  const BBCodeEditorToolbarDividerButton({required this.controller, super.key});

  /// Injected editor controller.
  final BBCodeEditorController controller;

  @override
  Widget build(BuildContext context) {
    return QuillToolbarIconButton(
      icon: const Icon(Icons.horizontal_rule_outlined),
      tooltip: context.bbcodeL10n.divider,
      iconTheme: const QuillIconTheme(),
      isSelected: false,
      onPressed: () async => controller.insertEmbeddable(BBCodeDividerEmbed()),
    );
  }
}
