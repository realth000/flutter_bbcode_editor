import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/embed_piece_container.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/tags/free/free_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Free header builder.
final class BBCodeFreeHeaderEmbedBuilder extends EmbedBuilder {
  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: widget));
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
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final textTheme = Theme.of(context).textTheme;

    return EmbedPieceContainer(
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Icon(Icons.arrow_drop_down_outlined, color: secondaryColor),
            const SizedBox(width: 8),
            Icon(Icons.money_off_outlined, color: primaryColor),
            const SizedBox(width: 8),
            Text(tr.free, style: textTheme.titleMedium?.copyWith(color: primaryColor)),
            const SizedBox(width: 8),
            Expanded(child: Text(tr.freeHeaderTip, style: textTheme.labelSmall?.copyWith(color: outlineColor))),
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
    return WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: widget));
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
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final textTheme = Theme.of(context).textTheme;

    return EmbedPieceContainer(
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Icon(Icons.arrow_drop_up_outlined, color: secondaryColor),
            const SizedBox(width: 8),
            Icon(Icons.money_off_outlined, color: primaryColor),
            const SizedBox(width: 8),
            Text(tr.free, style: textTheme.titleMedium?.copyWith(color: primaryColor)),
            const SizedBox(width: 8),
            Expanded(child: Text(tr.freeTailTip, style: textTheme.labelSmall?.copyWith(color: outlineColor))),
          ],
        ),
      ),
    );
  }
}
