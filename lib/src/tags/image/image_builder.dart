import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/l10n/l10n_widget.dart';
import 'package:flutter_bbcode_editor/src/tags/image/image_button.dart';
import 'package:flutter_bbcode_editor/src/tags/image/image_embed.dart';
import 'package:flutter_bbcode_editor/src/tags/image/image_keys.dart';
import 'package:flutter_bbcode_editor/src/types.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Editor widget builder for embed image types.
///
/// Only web images.
final class BBCodeImageEmbedBuilder extends EmbedBuilder {
  /// Constructor.
  BBCodeImageEmbedBuilder(
    this._bbCodeImageProvider,
    this._imagePicker, {
    this.constraints,
  });

  final BBCodeImageProvider? _bbCodeImageProvider;

  final BBCodeImagePicker? _imagePicker;

  /// Optional size constraints on rendered image.
  BoxConstraints? constraints;

  Future<void> _onEditImage(
    BuildContext context,
    QuillController controller,
    Embed node,
  ) async {
    final imageInfo = BBCodeImageInfo.fromJson(node.value.data as String);
    BBCodeImageInfo? info;
    if (_imagePicker != null) {
      info = await _imagePicker(
        context,
        imageInfo.link,
        imageInfo.width,
        imageInfo.height,
      );
    } else {
      info = await showDialog<BBCodeImageInfo>(
        context: context,
        builder: (_) => BBCodeLocalizationsWidget(
          child: PickImageDialog(
            link: imageInfo.link,
            width: imageInfo.width,
            height: imageInfo.height,
          ),
        ),
      );
    }

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
      BBCodeImageEmbed(info),
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
    final imageInfo = BBCodeImageInfo.fromJson(node.value.data as String);
    await Clipboard.setData(
      ClipboardData(text: imageInfo.link),
    );
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  String get key => BBCodeImageKeys.type;

  @override
  bool get expanded => false;

  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(
      child: Padding(
        // Add padding to avoid covering cursor.
        padding: const EdgeInsets.only(left: 2),
        child: widget,
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
    EmbedContext embedContext,
  ) {
    final tr = context.bbcodeL10n;
    final info =
        BBCodeImageInfo.fromJson(embedContext.node.value.data as String);
    final link = info.link;
    final width = info.width;
    final height = info.height;

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
                      onTap: embedContext.readOnly
                          ? null
                          : () async => _onEditImage(
                                context,
                                embedContext.controller,
                                embedContext.node,
                              ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: Text(tr.imageBuilderDialogDelete),
                      onTap: embedContext.readOnly
                          ? null
                          : () async => _onDelete(
                                context,
                                embedContext.controller,
                                embedContext.node,
                              ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.copy),
                      title: Text(tr.imageBuilderDialogCopyLink),
                      onTap: () async => _onCopy(
                        context,
                        embedContext.controller,
                        embedContext.node,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      child: Material(
        child: Padding(
          padding: const EdgeInsets.only(left: 2, top: 8, right: 2),
          child: Badge(
            label: Text('${width}x$height'),
            isLabelVisible:
                _bbCodeImageProvider != null && width != null && height != null,
            alignment: Alignment.topLeft,
            child: _bbCodeImageProvider?.call(
                  context,
                  link,
                  width,
                  height,
                ) ??
                Image.network(link),
          ),
        ),
      ),
    );
  }
}
