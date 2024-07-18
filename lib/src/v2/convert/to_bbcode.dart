// refer: https://github.com/singerdmx/flutter-quill/blob/master/lib/src/packages/quill_markdown/delta_to_markdown.dart

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bbcode_editor/src/v2/constants.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/image/image_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

typedef EmbedToBBCode = void Function(Embed embed, StringSink out);

class _AttributeHandler {
  const _AttributeHandler({
    this.beforeContent,
    this.afterContent,
  });

  final void Function(
    Attribute<Object?> attribute,
    Node node,
    StringSink output,
  )? beforeContent;

  final void Function(
    Attribute<Object?> attribute,
    Node node,
    StringSink output,
  )? afterContent;
}

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
    print('>>> accept! $runtimeType');
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

  bool containsAttr(String attributeKey, [Object? value]) {
    if (!style.containsKey(attributeKey)) {
      return false;
    }
    if (value == null) {
      return true;
    }
    return style.attributes[attributeKey]!.value == value;
  }

  T getAttrValueOr<T>(String attributeKey, T or) {
    final attrs = style.attributes;
    final attrValue = attrs[attributeKey]?.value as T?;
    return attrValue ?? or;
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
        (attr1, attr2) => attrCount[attr2]!.compareTo(attrCount[attr1]!));

    return attrs;
  }
}

class DeltaToBBCode extends Converter<Delta, String>
    implements _NodeVisitor<StringSink> {
  final Map<String, EmbedToBBCode> _embedHandlers = {
    BBCodeEmbedTypes.image: (embed, out) {
      final d1 = jsonDecode(embed.value.data as String) as Map<String, dynamic>;
      final imageInfo = BBCodeImageInfo.fromJson(
          jsonDecode(d1[BBCodeEmbedTypes.image] as String)
              as Map<String, dynamic>);
      out.write('[img=${imageInfo.width},${imageInfo.height}]'
          '${imageInfo.link}'
          '[/img]');
    },
  };

  final Map<String, _AttributeHandler> _blockAttrsHandlers = {
    Attribute.codeBlock.key: _AttributeHandler(
      beforeContent: (attribute, node, output) => output.write('[code]'),
      afterContent: (attribute, node, output) => output.write('[/code]'),
    ),
    Attribute.blockQuote.key: _AttributeHandler(
      beforeContent: (attribute, node, output) => output.write('[quote]'),
      afterContent: (attribute, node, output) => output.write('[/quote]'),
    ),
  };

  final Map<String, _AttributeHandler> _lineAttrsHandlers = {
    // TODO: Implement line attr handlers.
  };

  void _handleAttribute(
    Map<String, _AttributeHandler> handlers,
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

  @override
  String convert(Delta input) {
    // final newDelta = transform(input);
    final quillDocument = Document.fromDelta(input);
    final outBuffer = quillDocument.root.accept(this);
    return outBuffer.toString();
  }

  @override
  StringSink visitBlock(Block block, [StringSink? output]) {
    print('>>> visitBlock');
    final out = output ??= StringBuffer();
    _handleAttribute(_blockAttrsHandlers, block, output, () {
      for (final line in block.children) {
        line.accept(this, out);
      }
    });
    return out;
  }

  @override
  StringSink visitEmbed(Embed embed, [StringSink? output]) {
    print('>>> visitEmbed');
    final out = output ??= StringBuffer();
    final embedDataMap =
        jsonDecode(embed.value.data as String) as Map<String, dynamic>;
    final type = embedDataMap.keys.first;
    print('>>> type $type, data=${embedDataMap[type]}');
    _embedHandlers[type]?.call(embed, out);
    return out;
  }

  @override
  StringSink visitLine(Line line, [StringSink? output]) {
    print('>>> visitLine: hasEmbed=${line.hasEmbed}');
    // TODO: implement visitLine
    final out = output ??= StringBuffer();
    final style = line.style;
    _handleAttribute(_lineAttrsHandlers, line, output, () {
      for (final leaf in line.children) {
        leaf.accept(this, out);
      }
    });
    if (style.isEmpty ||
        style.values.every((item) => item.scope != AttributeScope.block)) {
      out.writeln();
    }
    if (style.containsKey(Attribute.list.key) &&
        line.nextLine?.style.containsKey(Attribute.list.key) != true) {
      out.writeln();
    }
    out.writeln();
    return out;
  }

  @override
  StringSink visitRoot(Root root, [StringSink? output]) {
    print('>>> visitRoot');
    final out = output ??= StringBuffer();
    for (final container in root.children) {
      container.accept(this, out);
    }
    return out;
  }

  @override
  StringSink visitText(QuillText text, [StringSink? output]) {
    print('>>> visitText');
    // TODO: implement visitText
    final out = output ??= StringBuffer();
    out.writeln(text);
    return out;
  }
}
