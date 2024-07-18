import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';
import 'package:flutter_bbcode_editor/src/l10n/l10n_widget.dart';
import 'package:flutter_bbcode_editor/src/v2/constants.dart';
import 'package:flutter_bbcode_editor/src/v2/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/image/image_keys.dart';
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

final class PickImageDialog extends StatefulWidget {
  const PickImageDialog({
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
  State<PickImageDialog> createState() => _PickImageDialogState();
}

class _PickImageDialogState extends State<PickImageDialog> {
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
              BBCodeImageInfo(
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

  Future<void> _waitInputUrlImage(BuildContext context) async {
    final imageInfo = await showDialog<BBCodeImageInfo>(
      context: context,
      builder: (_) => BBCodeLocalizationsWidget(
        child: FlutterQuillLocalizationsWidget(
          child: PickImageDialog(dialogTheme: dialogTheme),
        ),
      ),
    );
    if (imageInfo == null) {
      return;
    }

    print('>>>> get imageInfo: $imageInfo');

    controller.insertEmbedBlock(
      BBCodeEmbedTypes.image,
      jsonEncode(imageInfo.toJson()),
    );

    return;
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
