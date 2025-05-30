import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/embed_piece_container.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/tags/free/free_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Free header builder.
final class BBCodeFreeHeaderEmbedBuilder extends EmbedBuilder {
  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), child: widget));
  }

  @override
  bool get expanded => false;

  @override
  String get key => BBCodeFreeKeys.headerType;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final tr = context.bbcodeL10n;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final outlineColor = Theme.of(context).colorScheme.outline;
    final textTheme = Theme.of(context).textTheme;

    return EmbedPieceContainer(
      pieceType: EmbedPieceType.header,
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Icon(Icons.money_off_outlined, color: primaryColor),
            const SizedBox(width: 8),
            Text(tr.free, style: textTheme.titleMedium?.copyWith(color: primaryColor)),
            const SizedBox(width: 8),
            Flexible(child: Text(tr.freeHeaderTip, style: textTheme.labelSmall?.copyWith(color: outlineColor))),
            Icon(Icons.arrow_drop_down_outlined, color: outlineColor),
          ],
        ),
      ),
    );
  }
}

/// Free tail builder.
final class BBCodeFreeTailEmbedBuilder extends EmbedBuilder {
  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), child: widget));
  }

  @override
  bool get expanded => false;

  @override
  String get key => BBCodeFreeKeys.tailType;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final tr = context.bbcodeL10n;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final outlineColor = Theme.of(context).colorScheme.outline;
    final textTheme = Theme.of(context).textTheme;

    return EmbedPieceContainer(
      pieceType: EmbedPieceType.tail,
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Icon(Icons.money_off_outlined, color: primaryColor),
            const SizedBox(width: 8),
            Text(tr.free, style: textTheme.titleMedium?.copyWith(color: primaryColor)),
            const SizedBox(width: 8),
            Flexible(child: Text(tr.freeTailTip, style: textTheme.labelSmall?.copyWith(color: outlineColor))),
            Icon(Icons.arrow_drop_up_outlined, color: outlineColor),
          ],
        ),
      ),
    );
  }
}
