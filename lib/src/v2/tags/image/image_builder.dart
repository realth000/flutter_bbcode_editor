import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bbcode_editor/src/l10n/l10n_widget.dart';
import 'package:flutter_bbcode_editor/src/v2/constants.dart';
import 'package:flutter_bbcode_editor/src/v2/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/image/image_button.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/image/image_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Editor widget builder for embed image types.
///
/// Only web images.
final class BBCodeImageEmbedBuilder extends EmbedBuilder {
  Future<void> _onEditImage(
    BuildContext context,
    QuillController controller,
    Embed node,
  ) async {
    final imageInfo = BBCodeImageInfo.fromJson(
      jsonDecode(node.value.data as String) as Map<String, dynamic>,
    );
    final info = await showDialog<BBCodeImageInfo>(
      context: context,
      builder: (_) => BBCodeLocalizationsWidget(
        child: PickImageDialog(
          link: imageInfo.link,
          width: imageInfo.width,
          height: imageInfo.height,
        ),
      ),
    );
    if (info == null) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      return;
    }

    final offset = getEmbedNode(
      controller,
      controller.selection.start,
    ).offset;
    controller.replaceText(
      offset,
      1,
      BlockEmbed.custom(
        CustomBlockEmbed(
          BBCodeEmbedTypes.image,
          jsonEncode(info.toJson()),
        ),
      ),
      TextSelection.collapsed(offset: offset),
    );

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _onDelete(
    BuildContext context,
    QuillController controller,
    Embed node,
  ) async {
    final offset = getEmbedNode(
      controller,
      controller.selection.start,
    ).offset;
    controller.replaceText(
      offset,
      1,
      '',
      TextSelection.collapsed(offset: offset),
    );
    // TODO: Handle on image remove callback.
    Navigator.of(context).pop();
  }

  Future<void> _onCopy(
    BuildContext context,
    QuillController controller,
    Embed node,
  ) async {
    final imageInfo = BBCodeImageInfo.fromJson(
      jsonDecode(node.value.data as String) as Map<String, dynamic>,
    );
    await Clipboard.setData(
      ClipboardData(text: imageInfo.link),
    );
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  String get key => BBCodeEmbedTypes.image;

  @override
  bool get expanded => false;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final tr = context.bbcodeL10n;
    final data = jsonDecode(node.value.data as String) as Map<String, dynamic>;
    final link = data[ImageKeys.link] as String;

    return GestureDetector(
      onTap: () async {
        await showModalBottomSheet<void>(
          context: context,
          builder: (_) => Scaffold(
            appBar: AppBar(
              forceMaterialTransparency: true,
              title: Text(tr.imageBuilderDialogTitle),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: Text(tr.imageBuilderDialogEdit),
                    onTap: readOnly
                        ? null
                        : () async => _onEditImage(context, controller, node),
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: Text(tr.imageBuilderDialogDelete),
                    onTap: readOnly
                        ? null
                        : () async => _onDelete(context, controller, node),
                  ),
                  ListTile(
                    leading: const Icon(Icons.copy),
                    title: Text(tr.imageBuilderDialogCopyLink),
                    onTap: () async => _onCopy(context, controller, node),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Image.network(link),
    );
  }
}
