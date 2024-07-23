import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/l10n/l10n_widget.dart';
import 'package:flutter_bbcode_editor/src/tags/image/image_button.dart';
import 'package:flutter_bbcode_editor/src/tags/image/image_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// External function build a image widget from given image [url].
typedef BBCodeImageProvider = Widget Function(String url);

/// Editor widget builder for embed image types.
///
/// Only web images.
final class BBCodeImageEmbedBuilder extends EmbedBuilder {
  /// Constructor.
  const BBCodeImageEmbedBuilder(this._bbCodeImageProvider);

  final BBCodeImageProvider? _bbCodeImageProvider;

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
          builder: (_) => Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TODO: Optional bottom sheet title.
                // Center(
                //   child: Text(
                //     tr.imageBuilderDialogTitle,
                //     style: Theme.of(context).textTheme.titleMedium,
                //   ),
                // ),
                ListView(
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
              ],
            ),
          ),
        );
      },
      child: _bbCodeImageProvider?.call(link) ?? Image.network(link),
    );
  }
}
