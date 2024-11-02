// refer: https://github.com/singerdmx/flutter-quill/blob/master/lib/src/packages/quill_markdown/delta_to_markdown.dart

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/tags/emoji/emoji_embed.dart';
import 'package:flutter_bbcode_editor/src/tags/emoji/emoji_keys.dart';
import 'package:flutter_bbcode_editor/src/tags/image/image_embed.dart';
import 'package:flutter_bbcode_editor/src/tags/image/image_keys.dart';
import 'package:flutter_bbcode_editor/src/tags/user_mention/user_mention_embed.dart';
import 'package:flutter_bbcode_editor/src/tags/user_mention/user_mention_keys.dart';
import 'package:flutter_bbcode_editor/src/types.dart';
import 'package:flutter_bbcode_editor/src/utils.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

/// Bellow are default attribute handlers for different delta node types.

/// Default attribute handlers for block type nodes.
///
/// Block is a kind of node that consumes the entire row(s).
///
/// * Code block.
/// * Quote block.
final AttrHandlerMap defaultBlockAttrHandlers = {
  Attribute.codeBlock.key: BBCodeAttributeHandler(
    beforeContent: (attribute, node, output) => output.write('[code]'),
    afterContent: (attribute, node, output) => output.write('[/code]'),
  ),
  Attribute.blockQuote.key: BBCodeAttributeHandler(
    beforeContent: (attribute, node, output) => output.write('[quote]'),
    afterContent: (attribute, node, output) => output.write('[/quote]'),
  ),
};

/// Default attribute handlers for embed nodes.
///
/// Embed is a kind of node that represent in another form (like image).
///
/// * Image.
final Map<String, EmbedToBBCode> defaultEmbedHandlers = {
  BBCodeEmojiKeys.type: BBCodeEmojiInfo.toBBCode,
  BBCodeImageKeys.type: BBCodeImageInfo.toBBCode,
  BBCodeUserMentionKeys.type: BBCodeUserMentionInfo.toBBCode,
};

/// Default attribute handlers for line nodes.
///
/// Line is a kind of node that decorating the whole line, have effect on the
/// row and all things inside the row.
///
/// * Align.
/// * Ordered list and bullet list.
final AttrHandlerMap defaultLineAttrHandlers = {
  // Align.
  //
  // * Align left
  // * Align center
  // * Align right
  Attribute.align.key: BBCodeAttributeHandler(
    beforeContent: (attribute, node, output) =>
        output.write('[align=${attribute.value}]'),
    afterContent: (attribute, node, output) => output.write('[/align]'),
  ),
  // Ordered list and bullet list.
  //
  //
  // Ordered list:
  //
  // [list=1]
  // [*] foo
  // [*] bar
  // [*] baz
  // [/list]
  //
  // Bullet list:
  //
  // [list]
  // [*] foo
  // [*] bar
  // [*] baz
  // [/list]
  Attribute.list.key: BBCodeAttributeHandler(
    beforeContent: (attribute, node, output) {
      if (node.previous == null) {
        final listType =
            node.style.attributes[Attribute.list.key]!.value as String;
        final listHead = switch (listType) {
          'ordered' => '[list=1]',
          'bullet' => '[list]',
          String() => '', // Impossible
        };
        output.writeln(listHead);
      }
      output.write('[*]');
    },
    afterContent: (attribute, node, output) {
      if (node.next == null) {
        output
          ..writeln()
          ..write('[/list]');
      }
    },
  ),
};

/// Default text attribute handlers.
///
/// Text is a kind of node that only works on a part of text.
///
/// * Bold.
/// * Italic.
/// * Underline.
/// * Strikethrough.
/// * Subscript, only superscript.
/// * Color.
/// * Background color.
/// * Url.
final AttrHandlerMap defaultTextAttrHandlers = {
  Attribute.size.key: BBCodeAttributeHandler(
    beforeContent: (attr, node, output) {
      final size = defaultFontSizeMap.entries
          .firstWhereOrNull(
            (e) => e.value == (attr.value as double?).toString(),
          )
          ?.key;
      output.write('[size=${size ?? "0"}]');
    },
    afterContent: (attr, node, output) => output.write('[/size]'),
  ),
  // Bold.
  Attribute.bold.key: BBCodeAttributeHandler(
    beforeContent: (attribute, node, output) => output.write('[b]'),
    afterContent: (attribute, node, output) => output.write('[/b]'),
  ),
  // Italic.
  Attribute.italic.key: BBCodeAttributeHandler(
    beforeContent: (attribute, node, output) => output.write('[i]'),
    afterContent: (attribute, node, output) => output.write('[/i]'),
  ),
  // Underline.
  Attribute.underline.key: BBCodeAttributeHandler(
    beforeContent: (attribute, node, output) => output.write('[u]'),
    afterContent: (attribute, node, output) => output.write('[/u]'),
  ),
  // Strikethrough.
  Attribute.strikeThrough.key: BBCodeAttributeHandler(
    beforeContent: (attribute, node, output) => output.write('[s]'),
    afterContent: (attribute, node, output) => output.write('[/s]'),
  ),
  // Currently only support superscript.
  // Superscript.
  Attribute.subscript.key: BBCodeAttributeHandler(
    beforeContent: (attribute, node, output) {
      if (attribute.value.toString() != 'super') {
        return;
      }
      output.write('[sup]');
    },
    afterContent: (attribute, node, output) {
      if (attribute.value.toString() != 'super') {
        return;
      }
      output.write('[/sup]');
    },
  ),
  // Font color.
  Attribute.color.key: BBCodeAttributeHandler(
    beforeContent: (attribute, node, output) => output.write(
      '[color=${ColorUtils.toBBCodeColor(attribute.value as String? ?? "")}]',
    ),
    afterContent: (attribute, node, output) => output.write('[/color]'),
  ),
  // Background color.
  Attribute.background.key: BBCodeAttributeHandler(
    beforeContent: (attribute, node, output) => output.write(
      '[backcolor='
      '${ColorUtils.toBBCodeColor(attribute.value as String? ?? "")}]',
    ),
    afterContent: (attribute, node, output) => output.write('[/backcolor]'),
  ),
  // Url
  Attribute.link.key: BBCodeAttributeHandler(
    beforeContent: (attribute, node, output) => output.write(
      '[url=${attribute.value as String? ?? ""}]',
    ),
    afterContent: (attribute, node, output) => output.write('[/url]'),
  ),
};

/// Handler a specified attribute.
///
/// Prepend or append format text before or after real content text.
///
/// For example, for bolded text:
///
/// ```bbcode
/// [b]foo[/b]
/// ```
///
/// * [beforeContent] adds `[b]` before `foo`.
/// * [afterContent] adds `[/b]` after `foo`.
class BBCodeAttributeHandler {
  /// Constructor.
  const BBCodeAttributeHandler({
    this.beforeContent,
    this.afterContent,
    this.contentHandler,
  });

  /// Prepend text before text content.
  final void Function(
    Attribute<Object?> attribute,
    Node node,
    StringSink output,
  )? beforeContent;

  /// Append text after text content.
  final void Function(
    Attribute<Object?> attribute,
    Node node,
    StringSink output,
  )? afterContent;

  /// Optional function to transform content text.
  ///
  /// Return the transformed text.
  final String Function(String content)? contentHandler;
}

/// A map of attribute handlers.
///
/// All
typedef AttrHandlerMap = Map<String, BBCodeAttributeHandler>;

abstract class _NodeVisitor<T> {
  const _NodeVisitor._();

  T visitRoot(Root root, [T? context]);

  T visitBlock(Block block, [T? context]);

  T visitLine(Line line, [T? context]);

  T visitText(QuillText text, [T? context]);

  T visitEmbed(Embed embed, [T? context]);
}

extension _NodeX on Node {
  T accept<T>(_NodeVisitor<T> visitor, [T? context]) {
    switch (runtimeType) {
      case const (Root):
        return visitor.visitRoot(this as Root, context);
      case const (Block):
        return visitor.visitBlock(this as Block, context);
      case const (Line):
        return visitor.visitLine(this as Line, context);
      case const (QuillText):
        return visitor.visitText(this as QuillText, context);
      case const (Embed):
        return visitor.visitEmbed(this as Embed, context);
    }
    throw Exception('Container of type $runtimeType cannot be visited');
  }

  List<Attribute<Object?>> attrsSortedByLongestSpan() {
    final attrCount = <Attribute<dynamic>, int>{};
    var node = this;
    // get the first node
    while (node.previous != null) {
      node = node.previous!;
      node.style.attributes.forEach((key, value) {
        attrCount[value] = (attrCount[value] ?? 0) + 1;
      });
      node = node.next!;
    }

    final attrs = style.attributes.values.sorted(
      (attr1, attr2) => attrCount[attr2]!.compareTo(attrCount[attr1]!),
    );

    return attrs;
  }
}

/// Convert quilt delta into bbcode.
class DeltaToBBCode extends Converter<Delta, String>
    implements _NodeVisitor<StringSink> {
  void _handleAttribute(
    Map<String, BBCodeAttributeHandler> handlers,
    Node node,
    StringSink output,
    VoidCallback contentHandler, {
    bool sortedAttrsBySpan = false,
  }) {
    final attrs = sortedAttrsBySpan
        ? node.attrsSortedByLongestSpan()
        : node.style.attributes.values.toList();
    final handlersToUse = attrs
        .where((attr) => handlers.containsKey(attr.key))
        .map((attr) => MapEntry(attr.key, handlers[attr.key]!))
        .toList();
    for (final handlerEntry in handlersToUse) {
      handlerEntry.value.beforeContent?.call(
        node.style.attributes[handlerEntry.key]!,
        node,
        output,
      );
    }
    contentHandler();
    for (final handlerEntry in handlersToUse.reversed) {
      handlerEntry.value.afterContent?.call(
        node.style.attributes[handlerEntry.key]!,
        node,
        output,
      );
    }
  }

  void _handleTextAttribute(
    Map<String, BBCodeAttributeHandler> handlers,
    QuillText text,
    StringSink output,
    void Function(String) contentHandler, {
    bool sortedAttrsBySpan = false,
  }) {
    final attrs = sortedAttrsBySpan
        ? text.attrsSortedByLongestSpan()
        : text.style.attributes.values.toList();
    final handlersToUse = attrs
        .where((attr) => handlers.containsKey(attr.key))
        .map((attr) => MapEntry(attr.key, handlers[attr.key]!))
        .toList();
    var transformedText = text.value;
    for (final handlerEntry in handlersToUse) {
      handlerEntry.value.beforeContent?.call(
        text.style.attributes[handlerEntry.key]!,
        text,
        output,
      );
      transformedText =
          handlerEntry.value.contentHandler?.call(transformedText) ??
              transformedText;
    }
    contentHandler(transformedText);
    for (final handlerEntry in handlersToUse.reversed) {
      handlerEntry.value.afterContent?.call(
        text.style.attributes[handlerEntry.key]!,
        text,
        output,
      );
    }
  }

  /// Entry function to convert quilt delta to bbcode.
  @override
  String convert(Delta input) {
    // final newDelta = transform(input);
    final quillDocument = Document.fromDelta(input);
    final outBuffer = quillDocument.root.accept(this);
    return outBuffer.toString();
  }

  @override
  StringSink visitBlock(Block block, [StringSink? output]) {
    final out = output ??= StringBuffer();
    _handleAttribute(defaultBlockAttrHandlers, block, output, () {
      for (final line in block.children) {
        line.accept(this, out);
      }
    });
    return out;
  }

  @override
  StringSink visitEmbed(Embed embed, [StringSink? output]) {
    final out = output ??= StringBuffer();
    defaultEmbedHandlers[embed.value.type]?.call(embed, out);
    return out;
  }

  @override
  StringSink visitLine(Line line, [StringSink? output]) {
    // TODO: implement visitLine
    final out = output ??= StringBuffer();
    _handleAttribute(defaultLineAttrHandlers, line, output, () {
      for (final leaf in line.children) {
        leaf.accept(this, out);
      }
    });
    // if (style.isEmpty ||
    //     style.values.every((item) => item.scope != AttributeScope.block)) {
    //   out.writeln();
    // }
    // if (style.containsKey(Attribute.list.key) &&
    //     line.nextLine?.style.containsKey(Attribute.list.key) != true) {
    // }
    out.writeln();
    return out;
  }

  @override
  StringSink visitRoot(Root root, [StringSink? output]) {
    final out = output ??= StringBuffer();
    for (final container in root.children) {
      container.accept(this, out);
    }
    return out;
  }

  @override
  StringSink visitText(QuillText text, [StringSink? output]) {
    // TODO: implement visitText
    final out = output ??= StringBuffer();
    _handleTextAttribute(defaultTextAttrHandlers, text, output, out.write);
    return out;
  }
}
