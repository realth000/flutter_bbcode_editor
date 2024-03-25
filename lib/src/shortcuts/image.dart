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

  /// Picture display width.
  ///
  /// Value is double type and value should not be negative.
  static const String width = 'width';

  /// Picture display height.
  ///
  /// Value is double type and value should not be negative.
  static const String height = 'height';
}

/// Internal function to build an image component from given [url].
///
/// Build image with size [width] and [height].
InlineSpan bbcodeInlineImageBuilder(
  BuildContext context,
  String url,
  double width,
  double height,
  ImageProvider imageProvider,
  ImageLoadingBuilder imageLoadingBuilder,
  ImageErrorBuilder imageErrorBuilder,
) {
  return WidgetSpan(
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
          ),
        ),
        width: width,
        height: height,
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
  ) async {
    assert(width > 0 && height > 0, 'Image size should not be negative values');
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
    if (width == null || width <= 0 || height == null || height <= 0) {
      return false;
    }
    return true;
  }
}
