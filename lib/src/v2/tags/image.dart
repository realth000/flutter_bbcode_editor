import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/translations.dart';

final class _ImageInfo {
  const _ImageInfo(
    this.link, {
    this.width,
    this.height,
  });

  final String link;
  final int? width;
  final int? height;
}

final class _PickImageDialog extends StatefulWidget {
  const _PickImageDialog({
    this.link,
    this.width,
    this.height,
    this.dialogTheme,
    super.key,
  });

  final QuillDialogTheme? dialogTheme;
  final String? link;
  final int? width;
  final int? height;

  @override
  State<_PickImageDialog> createState() => _PickImageDialogState();
}

class _PickImageDialogState extends State<_PickImageDialog> {
  late TextEditingController linkController;
  late TextEditingController widthController;
  late TextEditingController heightController;
  late String link;
  late int? width;
  late int? height;

  @override
  void initState() {
    super.initState();
    width = widget.width;
    height = widget.height;
    link = widget.link ?? '';
    linkController = TextEditingController(text: link);
    widthController = TextEditingController(text: '${width ?? ""}');
    heightController = TextEditingController(text: '${height ?? ""}');
  }

  @override
  void dispose() {
    linkController.dispose();
    widthController.dispose();
    heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.dialogTheme?.dialogBackgroundColor,
      content: Column(
        children: [
          //
        ],
      ),
    );
  }
}

/// Image block button.
class BBCodeEditorToolbarImageButton extends StatelessWidget {
  /// Constructor.
  const BBCodeEditorToolbarImageButton({
    required this.controller,
    this.dialogTheme,
    super.key,
  });

  /// Injected editor controller.
  final BBCodeEditorController controller;
  final QuillDialogTheme? dialogTheme;

  Future<String?> _waitInputUrlImage(BuildContext context) async {
    final value = await showDialog<String>(
      context: context,
      builder: (_) => FlutterQuillLocalizationsWidget(
        child: _PickImageDialog(dialogTheme: dialogTheme),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return QuillToolbarIconButton(
      icon: const Icon(Icons.image),
      tooltip: context.loc.insertImage,
      isSelected: false,
      onPressed: () => _waitInputUrlImage(context),
    );
  }
}
