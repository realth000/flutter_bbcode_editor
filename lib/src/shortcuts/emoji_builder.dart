import 'dart:async';
import 'dart:typed_data';

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/shortcuts/emoji.dart';

/// Function that build a emoji [code] into emoji image data.
///
/// Use the text when return null (considered as invalid emoji [code]).
typedef EmojiBuilder = Future<Uint8List?> Function(String code);

class EmojiBlockComponentBuilder extends BlockComponentBuilder {
  EmojiBlockComponentBuilder({
    required this.emojiBuilder,
    super.configuration,
  });

  /// Build emoji bbcode into image data.
  ///
  /// Return null when code is invalid.
  final EmojiBuilder emojiBuilder;

  @override
  BlockComponentWidget build(BlockComponentContext blockComponentContext) {
    final node = blockComponentContext.node;
    return EmojiBlockComponentWidget(
      key: node.key,
      node: node,
      configuration: configuration,
      emojiBuilder: emojiBuilder,
    );
  }

  @override
  bool validate(Node node) => node.delta == null && node.children.isEmpty;
}

class EmojiBlockComponentWidget extends BlockComponentStatefulWidget {
  const EmojiBlockComponentWidget({
    super.key,
    required super.node,
    required this.emojiBuilder,
    super.configuration = const BlockComponentConfiguration(),
  });

  final EmojiBuilder emojiBuilder;

  @override
  State<EmojiBlockComponentWidget> createState() =>
      _EmojiBlockComponentWidgetState();
}

class _EmojiBlockComponentWidgetState extends State<EmojiBlockComponentWidget>
    with SelectableMixin, BlockComponentConfigurable {
  @override
  BlockComponentConfiguration get configuration => widget.configuration;

  @override
  Node get node => widget.node;

  final emojiKey = GlobalKey();

  RenderBox? get _renderBox => context.findRenderObject() as RenderBox?;

  @override
  Widget build(BuildContext context) {
    final node = widget.node;
    final attributes = node.attributes;
    final code = attributes[EmojiBlocKeys.code] as String;

    return FutureBuilder(
      future: widget.emojiBuilder(code),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return Image.memory(data);
        }
        return Text(code);
      },
    );
  }

  @override
  Position start() => Position(path: widget.node.path);

  @override
  Position end() => Position(path: widget.node.path, offset: 1);

  @override
  Rect getBlockRect({bool shiftWithBaseOffset = false}) {
    final box = emojiKey.currentContext?.findRenderObject();
    if (box is RenderBox) {
      return Offset.zero & box.size;
    }
    return Rect.zero;
  }

  @override
  Position getPositionInOffset(Offset start) => end();

  @override
  List<Rect> getRectsInSelection(Selection selection,
      {bool shiftWithBaseOffset = false}) {
    if (_renderBox == null) {
      return [];
    }
    final parentBox = context.findRenderObject();
    final box = emojiKey.currentContext?.findRenderObject();
    if (parentBox is RenderBox && box is RenderBox) {
      return [
        box.localToGlobal(Offset.zero, ancestor: parentBox) & box.size,
      ];
    }
    return [Offset.zero & _renderBox!.size];
  }

  @override
  Selection getSelectionInRange(Offset start, Offset end) => Selection.single(
        path: widget.node.path,
        startOffset: 0,
        endOffset: 1,
      );

  @override
  Offset localToGlobal(Offset offset, {bool shiftWithBaseOffset = false}) =>
      _renderBox!.localToGlobal(offset);
}
