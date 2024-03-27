import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';

/// Function to build a widget to show when loading image from [url].
typedef ImageLoadingBuilder = Widget Function(
  BuildContext context,
  String url,
);

/// Function to build a widget to show when failed to load image from [url].
///
/// The failed reason is [error].
typedef ImageErrorBuilder = Widget Function(
  BuildContext context,
  String url,
  String error,
);

/// Default builder to show widget when loading the image.
Widget defaultImageLoadingBuilder(
  BuildContext context,
  String url,
) {
  return RichText(
    text: TextSpan(
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      children: [
        const WidgetSpan(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(),
          ),
        ),
        const WidgetSpan(child: SizedBox(width: 5, height: 23)),
        WidgetSpan(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Text(
                url,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

/// Default builder to show widget when failed to build image.
Widget defaultImageErrorBuilder(
  BuildContext context,
  String url,
  String error,
) {
  return RichText(
    text: TextSpan(
      style: TextStyle(
        color: Theme.of(context).colorScheme.error,
        backgroundColor: Theme.of(context).colorScheme.errorContainer,
      ),
      children: [
        const WidgetSpan(
            child: Icon(Icons.image_not_supported_outlined, size: 23)),
        const WidgetSpan(child: SizedBox(width: 5, height: 23)),
        WidgetSpan(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Text(
                url,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

/// All document attributes keys used in bbcode image.
///
/// Image here is also a inline span.
class BBCodeImageBlockKeys {
  const BBCodeImageBlockKeys._();

  /// Type of the block.
  static const String type = 'image';

  /// Data here
  static const String link = 'link';

  /// Image width set in bbcode.
  ///
  /// Value is double type and value should not be negative.
  static const String width = 'width';

  /// Image height set in bbcode.
  ///
  /// Value is double type and value should not be negative.
  static const String height = 'height';

  /// Picture display width in editor.
  static const String displayWidth = 'displayWith';

  /// Picture display height in editor.
  static const String displayHeight = 'displayHeight';
}

/// Internal function to build an image component from given [url].
///
/// Build image with size [displayWidth] and [displayHeight].
InlineSpan bbcodeInlineImageBuilder(
  BuildContext context,
  String url,
  double displayWidth,
  double displayHeight,
  ImageProvider imageProvider,
  ImageLoadingBuilder imageLoadingBuilder,
  ImageErrorBuilder imageErrorBuilder,
) {
  return WidgetSpan(
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          image: DecorationImage(
            image: imageProvider,
            isAntiAlias: true,
          ),
        ),
        width: displayWidth,
        height: displayHeight,
      ),
    ),
  );
}

/// Provide methods related to image blocks.
extension ImageExtension on BBCodeEditorState {
  /// Insert image block.
  ///
  /// Build image from [url] and add as description.
  Future<void> insertImage(
    String url,
    double width,
    double height,
    double displayWidth,
    double displayHeight,
  ) async {
    assert(width > 0 && height > 0, 'Image size should not be negative values');
    assert(
      displayWidth > 0 && displayHeight > 0,
      'Image size should not be negative values',
    );
    if (editorState == null) {
      return;
    }

    final selection = this.selection ?? lastUsedSelection;
    if (selection == null || !selection.isCollapsed) {
      return;
    }
    final node = editorState!.getNodeAtPath(selection.end.path);
    if (node == null) {
      return;
    }
    final transaction = editorState!.transaction;

    final attr = {
      'bbcode': {
        'type': BBCodeImageBlockKeys.type,
        BBCodeImageBlockKeys.link: url,
        BBCodeImageBlockKeys.width: width,
        BBCodeImageBlockKeys.height: height,
        BBCodeImageBlockKeys.displayWidth: displayWidth,
        BBCodeImageBlockKeys.displayHeight: displayHeight,
      },
    };

    if (node.type == ParagraphBlockKeys.type &&
        (node.delta?.isEmpty ?? false)) {
      // TODO: Handle selection is expanded.
      transaction.insertText(
        node,
        selection.endIndex,
        r'$',
        attributes: attr,
      );
    } else {
      transaction.insertText(
        node,
        selection.endIndex,
        r'$',
        attributes: attr,
      );
    }

    transaction.afterSelection = Selection.collapsed(
      Position(
        path: node.path,
        offset: selection.endIndex + 1,
      ),
    );

    return editorState!.apply(transaction);
  }
}

extension CheckImage on Map<dynamic, dynamic> {
  bool get hasImage {
    if (this[BBCodeImageBlockKeys.link] is! String) {
      return false;
    }
    final width = this[BBCodeImageBlockKeys.width] as double?;
    final height = this[BBCodeImageBlockKeys.height] as double?;
    final displayWidth = this[BBCodeImageBlockKeys.displayWidth] as double?;
    final displayHeight = this[BBCodeImageBlockKeys.displayHeight] as double?;
    if (width == null ||
        width <= 0 ||
        height == null ||
        height <= 0 ||
        displayWidth == null ||
        displayWidth <= 0 ||
        displayHeight == null ||
        displayHeight <= 0) {
      return false;
    }
    return true;
  }
}

String? parseImageData(Map<String, dynamic> data) {
  final url = data[BBCodeImageBlockKeys.link];
  final width = data[BBCodeImageBlockKeys.width] as double?;
  final height = data[BBCodeImageBlockKeys.height] as double?;
  if (url == null || width == null || height == null) {
    return null;
  }
  return '[img=$width,$height]$url[/img]';
}
