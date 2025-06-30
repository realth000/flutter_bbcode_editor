import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/embed_piece_container.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/tags/hide_v2/hide_v2_embed.dart';
import 'package:flutter_bbcode_editor/src/tags/hide_v2/hide_v2_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Header embed builder.
final class BBCodeHideV2HeaderEmbedBuilder extends EmbedBuilder {
  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), child: widget));
  }

  @override
  bool get expanded => false;

  @override
  String get key => BBCodeHideV2Keys.headerType;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final info = BBCodeHideV2HeaderInfo.fromJson(embedContext.node.value.data as String);
    return _HideV2Header(embedContext, info.points);
  }
}

/// Tail embed builder.
final class BBCodeHideV2TailEmbedBuilder extends EmbedBuilder {
  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), child: widget));
  }

  @override
  bool get expanded => false;

  @override
  String get key => BBCodeHideV2Keys.tailType;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final tr = context.bbcodeL10n;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final outlineColor = Theme.of(context).colorScheme.outline;
    final textTheme = Theme.of(context).textTheme;

    return EmbedPieceContainer(
      pieceType: EmbedPieceType.tail,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.visibility_off_outlined, color: primaryColor),
              const SizedBox(width: 8),
              Text(tr.hideV2, style: textTheme.titleMedium?.copyWith(color: primaryColor)),
              const SizedBox(width: 8),
              Flexible(child: Text(tr.hideV2TailTip, style: textTheme.labelSmall?.copyWith(color: outlineColor))),
              Icon(Icons.keyboard_arrow_left_outlined, color: outlineColor),
            ],
          ),
          const SizedBox(height: 8),
          const Row(mainAxisSize: MainAxisSize.min, children: [Text('')]),
        ],
      ),
    );
  }
}

class _HideV2Header extends StatefulWidget {
  const _HideV2Header(this.embedContext, this.initialPoints);

  final EmbedContext embedContext;

  final int initialPoints;

  @override
  State<_HideV2Header> createState() => _HideV2HeaderState();
}

class _HideV2HeaderState extends State<_HideV2Header> {
  late EmbedContext embedContext;
  late int points;

  @override
  void initState() {
    super.initState();
    embedContext = widget.embedContext;
    points = widget.initialPoints;
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.bbcodeL10n;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final outlineColor = Theme.of(context).colorScheme.outline;
    final textTheme = Theme.of(context).textTheme;

    return EmbedPieceContainer(
      pieceType: EmbedPieceType.header,
      onTap: () async {
        embedContext.controller.moveCursorToPosition(embedContext.node.documentOffset + embedContext.node.length);
        final points = await showDialog<int>(
          context: context,
          builder: (dialogContext) => _HideV2EditPointsDialog(this.points, tr),
        );
        if (points == null || !context.mounted) {
          return;
        }
        final offset = getEmbedNode(embedContext.controller, embedContext.controller.selection.start).offset;
        setState(() {
          this.points = points;
        });

        embedContext.controller
          ..replaceText(
            offset,
            1,
            BBCodeHideV2HeaderEmbed(BBCodeHideV2HeaderInfo(points)),
            TextSelection.collapsed(offset: offset),
          )
          ..moveCursorToPosition(offset + 1);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.visibility_off_outlined, color: primaryColor),
              const SizedBox(width: 8),
              Text(tr.hideV2, style: textTheme.titleMedium?.copyWith(color: primaryColor)),
              const SizedBox(width: 8),
              Flexible(child: Text(tr.hideV2HeaderTip, style: textTheme.labelSmall?.copyWith(color: outlineColor))),
              Icon(Icons.keyboard_arrow_right_outlined, color: outlineColor),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (points > 0) ...[
                Text(tr.hideV2HeaderPointsRequired, style: textTheme.labelSmall?.copyWith(color: outlineColor)),
                Flexible(child: Text('$points', style: textTheme.bodyMedium?.copyWith(color: primaryColor))),
              ] else
                Text(tr.hideV2HeaderReplyRequired, style: textTheme.bodyMedium?.copyWith(color: primaryColor)),
            ],
          ),
        ],
      ),
    );
  }
}

class _HideV2EditPointsDialog extends StatefulWidget {
  const _HideV2EditPointsDialog(this.initialPoints, this.tr);

  final int initialPoints;

  final BBCodeL10n tr;

  @override
  State<_HideV2EditPointsDialog> createState() => _HideV2EditPointsDialogState();
}

class _HideV2EditPointsDialogState extends State<_HideV2EditPointsDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.initialPoints}');
    _focus = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.tr.hideV2EditPoints),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(helperText: widget.tr.hideV2EditPointsTip),
          focusNode: _focus,
          autofocus: true,
          controller: _controller,
          validator: (v) {
            if (v == null || v.isEmpty) {
              return widget.tr.hideV2EditPointsNotEmpty;
            }
            final vv = int.tryParse(v);
            if (vv == null) {
              return widget.tr.hideV2EditPointsInvalid;
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.tr.cancel, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              Navigator.of(context).pop(int.parse(_controller.text));
              return;
            }
            _focus.requestFocus();
          },
          child: Text(widget.tr.ok),
        ),
      ],
    );
  }
}
