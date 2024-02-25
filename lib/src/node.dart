import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/delta.dart';

/// Record state for multi-node bbcode components.
class BBCodeState {
  /// Munching ordered list or not.
  bool inOrderedList = false;

  /// Munching unordered list or not.
  bool inUnorderedList = false;
}

/// Define pre and post actions for multiline tags.
///
/// e.g. For ordered list:
///
/// ```
/// [list=1]
/// [*]data1
/// [*]data2
/// [*]data3
/// [/list]
/// ```
///
/// Before munching first `data1`, add `[list=1]` into data.
/// After munching last `data3`, add `[/list]` into data.
class _MultilineHandler {
  const _MultilineHandler({
    required this.tag,
    required this.headBuilder,
    required this.tailBuilder,
  });

  /// BBCode tag.
  ///
  /// Only call the pre and post callback when [tag] appears.
  final String tag;

  /// Append header to data.
  final String Function(BBCodeState bbCodeState) headBuilder;

  /// Append tail to data.
  final String Function(BBCodeState bbCodeState) tailBuilder;
}

final _multilineHandlerList = <_MultilineHandler>[
  _MultilineHandler(
    tag: docTagOrderedList,
    headBuilder: (state) {
      if (!state.inOrderedList) {
        state.inOrderedList = true;
        return '[list=1]';
      }
      return '';
    },
    tailBuilder: (state) {
      if (state.inOrderedList) {
        state.inOrderedList = false;
        return '[/list]';
      }
      return '';
    },
  ),
  _MultilineHandler(
    tag: docTagUnorderedList,
    headBuilder: (state) {
      if (!state.inUnorderedList) {
        state.inUnorderedList = true;
        return '[list]';
      }
      return '';
    },
    tailBuilder: (state) {
      if (state.inUnorderedList) {
        state.inUnorderedList = false;
        return '[/list]';
      }
      return '';
    },
  ),
];

/// Provides methods related to bbcode format.
///
/// About bbcode: https://en.wikipedia.org/wiki/BBCode
extension BBCodeNode on Node {
  /// Convert the text info into a single bbcode node.
  String toBBCode(BBCodeState state) {
    // TODO: Parse multiline quoted text.
    // TODO: Parse multiline code block.
    // TODO: Parse emoji.

    // Before adding current node into data, add the tail of current in progress
    // node types that finished (e.tag != type) here.
    final tailData = _multilineHandlerList
        .where((e) => e.tag != type)
        .map((e) => e.tailBuilder(state))
        .join();

    // Before adding current node into data, add the head of current node if
    // current node type multiline.
    final headData = _multilineHandlerList
            .firstWhereOrNull((e) => e.tag == type)
            ?.headBuilder
            .call(state) ??
        '';

    final bodyData = switch (type) {
      'page' => '',
      'heading' => _buildHeading(),
      'paragraph' => _buildParagraph(),
      'numbered_list' => _buildOrderedList(),
      'bulleted_list' => _buildUnorderedList(),
      'image' => _buildImage(),
      String() => '',
    };

    return '${tailData.isNotEmpty ? "$tailData\n" : ""}'
        '${headData.isNotEmpty ? "$headData\n" : ""}'
        '$bodyData';
  }

  /// Heading
  ///
  /// header will be converted to `size` tag.
  ///
  /// # Json Document
  ///
  /// ## Attr
  ///
  /// * `level`: required, header level, also the size value in bbcode format.
  ///
  /// # BBCode
  ///
  /// ```
  /// [size=$level]xxx[/size].
  /// ```
  ///
  /// ## Attr
  ///
  /// Required, available value: 1, 2, 3, 4, 5, 6, 7.
  String _buildHeading() {
    if (delta == null) {
      // Empty header.
      return '';
    }
    final level = switch (attributes['level']) {
      1 => '7',
      2 => '6',
      3 => '5',
      4 => '4',
      5 => '3',
      6 => '2',
      7 => '1',
      _ => '7', // Return the largest size to let user notice it.
    };
    final content = delta!.toBBCode();
    return '[size=$level]$content[/size]';
  }

  String _buildParagraph() {
    if (delta == null) {
      // Empty paragraph, return an empty string.
      return '';
    }
    final content = delta!.toBBCode();
    return content;
  }

  // TODO: Support multiline ordered list item.
  /// Ordered list
  ///
  /// Ordered list will be converted into `list=1` tag.
  ///
  /// ## Json Document
  ///
  /// ```
  /// flutter: level=1, type=bulleted_list, attr={delta: [{insert: unordered list item 1}]}delta_text="unordered list item 1", delta_attr=null,
  /// flutter: level=1, type=bulleted_list, attr={delta: [{insert: unordered list item 2}]}delta_text="unordered list item 2", delta_attr=null,
  /// ```
  ///
  /// ## BBCode
  ///
  /// ```
  /// [list=1]
  /// [*]$data1
  /// [*]$data2
  /// [*]$data3
  /// [/list]
  /// ```
  ///
  /// The data can be multiline, server will handle it automatically.
  ///
  String _buildOrderedList() {
    if (delta == null) {
      // Possible?
      return '[*]';
    }

    final content = delta!.toBBCode();
    return '[*]$content';
  }

  /// Unordered list
  ///
  /// Munch into `list` tag.
  ///
  /// ## BBCode
  ///
  /// ```
  /// [list]
  /// [*]$data1
  /// [*]$data2
  /// [*]$data3
  /// [/list]
  /// ```
  ///
  /// The data can be multiline, server will handle it automatically.
  String _buildUnorderedList() {
    if (delta == null) {
      // Possible!?
      return '[*]';
    }
    final content = delta!.toBBCode();
    return '[*]$content';
  }

  // TODO: Customize image size.
  // TODO: Customize image alignment (wrapped with [align=left/center/right]).
  /// Image
  ///
  /// Image will be converted into `img` tag.
  ///
  /// # Json Document
  ///
  /// ## Attr
  ///
  /// * `url`: Image url. Required.
  /// * `align`: Alignment, seems default is align to center. But in forum
  ///   images are aligned to left. So this attribute is ignored.
  ///
  /// # BBCode
  ///
  /// ```
  /// [img=$size]$url[url].
  /// ```
  ///
  /// * `size`: Image size, now we do not have an option for customizing the
  ///   size. Use 480x240 as the default image size.
  /// * `url`: Url to fetch the image data.
  ///
  String _buildImage() {
    // Only use attributes.
    final url = attributes['url'] as String? ?? '';
    return '[img=480,240]$url[/img]';
  }
}
