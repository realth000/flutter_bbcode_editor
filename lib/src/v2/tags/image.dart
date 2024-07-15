import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';
import 'package:flutter_bbcode_editor/src/v2/extensions/context.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/translations.dart';

final _imageSizeFormatters = [
  FilteringTextInputFormatter.allow(
    RegExp('[0-9]+'),
  ),
];

String? _validateImageSize(BuildContext context, String? v) {
  final tr = context.bbcodeL10n;
  if (v == null || v.trim().isEmpty) {
    return tr.imageDialogEmptySize;
  }
  final vv = int.tryParse(v);
  if (vv == null || vv <= 0) {
    return tr.imageDialogInvalidSize;
  }

  return null;
}

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
  final formKey = GlobalKey<FormState>();
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
    final tr = context.bbcodeL10n;
    return AlertDialog(
      backgroundColor: widget.dialogTheme?.dialogBackgroundColor,
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: linkController,
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.image),
                labelText: tr.imageDialogLink,
              ),
            ),
            TextFormField(
              controller: widthController,
              keyboardType: TextInputType.number,
              inputFormatters: _imageSizeFormatters,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.vertical_distribute),
                labelText: tr.imageDialogWidth,
              ),
              validator: (v) => _validateImageSize(context, v),
            ),
            TextFormField(
              controller: heightController,
              keyboardType: TextInputType.number,
              inputFormatters: _imageSizeFormatters,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.horizontal_distribute),
                labelText: tr.imageDialogHeight,
              ),
              validator: (v) => _validateImageSize(context, v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (formKey.currentState == null ||
                !(formKey.currentState!).validate()) {
              return;
            }

            Navigator.of(context).pop(
              _ImageInfo(
                linkController.text,
                width: int.tryParse(widthController.text),
                height: int.tryParse(heightController.text),
              ),
            );
          },
          child: Text(context.loc.ok),
        ),
      ],
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

  Future<ImageInfo?> _waitInputUrlImage(BuildContext context) async {
    final imageInfo = await showDialog<String>(
      context: context,
      builder: (_) => FlutterQuillLocalizationsWidget(
        child: _PickImageDialog(dialogTheme: dialogTheme),
      ),
    );
    if (imageInfo == null) {
      return null;
    }

    // TODO: Handle image insertion.
  }

  @override
  Widget build(BuildContext context) {
    return QuillToolbarIconButton(
      icon: const Icon(Icons.image),
      tooltip: context.loc.insertImage,
      isSelected: false,
      iconTheme: context.quillToolbarBaseButtonOptions?.iconTheme,
      onPressed: () => _waitInputUrlImage(context),
    );
  }
}
