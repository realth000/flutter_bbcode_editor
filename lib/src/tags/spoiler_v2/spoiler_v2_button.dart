import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/tags/spoiler_v2/spoiler_v2_embed.dart';
import 'package:flutter_quill/flutter_quill.dart';

// /// Toolbar button of bbcode editor.
// class BBCodeEditorToolbarSpoilerV2Button extends StatefulWidget {
//   /// Constructor.
//   const BBCodeEditorToolbarSpoilerV2Button({
//     required this.controller,
//     required this.options,
//     this.baseOptions,
//     super.key,
//   });
//
//   /// Injected controller.
//   final BBCodeEditorController controller;
//
//   /// Button options specified for v2 spoiler.
//   final BBCodeSpoilerV2ButtonOptions options;
//
//   /// Base options.
//   final QuillToolbarBaseButtonOptions? baseOptions;
//
//   @override
//   State<BBCodeEditorToolbarSpoilerV2Button> createState() => _BBCodeEditorToolbarSpoilerV2ButtonState();
// }
//
// class _BBCodeEditorToolbarSpoilerV2ButtonState extends State<BBCodeEditorToolbarSpoilerV2Button> {
//   @override
//   Widget build(BuildContext context) {
//     return QuillToolbarToggleStyleButton(
//       options: widget.options,
//       controller: widget.controller,
//       attribute: const SpoilerV2HeaderAttribute(),
//       baseOptions: widget.baseOptions,
//     );
//   }
// }
//
// /// Button options of v2 version spoiler.
// class BBCodeSpoilerV2ButtonOptions extends QuillToolbarToggleStyleButtonOptions {
//   /// Constructor.
//   const BBCodeSpoilerV2ButtonOptions({
//     required super.tooltip,
//     super.iconData = Icons.expand_circle_down_outlined,
//     super.afterButtonPressed,
//     super.childBuilder,
//   });
// }

/// Spoiler v2 button in toolbar.
class BBCodeEditorToolbarSpoilerV2Button extends StatelessWidget {
  /// Constructor.
  const BBCodeEditorToolbarSpoilerV2Button({required this.controller, this.afterPressed, super.key});

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
        controller
          ..skipRequestKeyboard = false
          ..insertEmbeddable(
            BBCodeSpoilerV2HeaderEmbed(BBCodeSpoilerV2HeaderInfo(context.bbcodeL10n.spoilerExpandOrCollapse)),
          )
          ..insertEmbeddable(BBCodeSpoilerV2TailEmbed())
          ..moveCursorToPosition(controller.selection.baseOffset - 1);
      },
      afterPressed: afterPressed,
    );
  }
}
