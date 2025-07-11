import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/embed_piece_container.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/tags/spoiler_v2/spoiler_v2_embed.dart';
import 'package:flutter_bbcode_editor/src/tags/spoiler_v2/spoiler_v2_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Header part of v2 version of spoiler.
///
/// Header is a text block on text, setting header types.
class SpoilerV2HeaderAttribute extends Attribute<bool> {
  /// Constructor.
  const SpoilerV2HeaderAttribute() : super(BBCodeSpoilerV2Keys.headerType, AttributeScope.block, true);
}

/// Tail of the v2 version spoiler.
class SpoilerV2TailAttribute extends Attribute<bool> {
  /// Constructor.
  const SpoilerV2TailAttribute() : super(BBCodeSpoilerV2Keys.headerType, AttributeScope.block, true);
}

/// Header embed builder.
final class BBCodeSpoilerV2HeaderEmbedBuilder extends EmbedBuilder {
  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), child: widget));
  }

  @override
  bool get expanded => false;

  @override
  String get key => BBCodeSpoilerV2Keys.headerType;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final info = BBCodeSpoilerV2HeaderInfo.fromJson(embedContext.node.value.data as String);
    return _SpoilerV2Header(embedContext, info.title);
  }
}

/// Tail embed builder.
final class BBCodeSpoilerV2TailEmbedBuilder extends EmbedBuilder {
  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), child: widget));
  }

  @override
  bool get expanded => false;

  @override
  String get key => BBCodeSpoilerV2Keys.tailType;

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
              Icon(Icons.expand_outlined, color: primaryColor),
              const SizedBox(width: 8),
              Text(tr.spoiler, style: textTheme.titleMedium?.copyWith(color: primaryColor)),
              const SizedBox(width: 8),
              Flexible(child: Text(tr.spoilerV2TailTip, style: textTheme.labelSmall?.copyWith(color: outlineColor))),
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

class _SpoilerV2Header extends StatefulWidget {
  const _SpoilerV2Header(this.embedContext, this.initialTitle);

  final EmbedContext embedContext;

  final String initialTitle;

  @override
  State<_SpoilerV2Header> createState() => _SpoilerV2HeaderState();
}

class _SpoilerV2HeaderState extends State<_SpoilerV2Header> {
  late EmbedContext embedContext;
  late String title;

  @override
  void initState() {
    super.initState();
    embedContext = widget.embedContext;
    title = widget.initialTitle;
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
        final title = await showDialog<String>(
          context: context,
          builder: (dialogContext) => _SpoilerV2EditTitleDialog(this.title, tr),
        );
        if (title == null || !context.mounted) {
          return;
        }
        final offset = getEmbedNode(embedContext.controller, embedContext.controller.selection.start).offset;
        setState(() {
          this.title = title;
        });
        embedContext.controller
          ..replaceText(
            offset,
            1,
            BBCodeSpoilerV2HeaderEmbed(BBCodeSpoilerV2HeaderInfo(title)),
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
              Icon(Icons.expand_outlined, color: primaryColor),
              const SizedBox(width: 8),
              Text(tr.spoiler, style: textTheme.titleMedium?.copyWith(color: primaryColor)),
              const SizedBox(width: 8),
              Flexible(child: Text(tr.spoilerV2HeaderTip, style: textTheme.labelSmall?.copyWith(color: outlineColor))),
              Icon(Icons.keyboard_arrow_right_outlined, color: outlineColor),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tr.spoilerV2HeaderTitleTip, style: textTheme.labelSmall?.copyWith(color: outlineColor)),
              Flexible(child: Text(title, style: textTheme.bodyMedium?.copyWith(color: primaryColor))),
            ],
          ),
        ],
      ),
    );
  }
}

/// Dialog to edit the title of spoiler header.
class _SpoilerV2EditTitleDialog extends StatefulWidget {
  /// Constructor.
  const _SpoilerV2EditTitleDialog(this.initialTitle, this.tr);

  /// Initial title.
  final String initialTitle;

  /// L10n.
  final BBCodeL10n tr;

  @override
  State<_SpoilerV2EditTitleDialog> createState() => _SpoilerV2EditTitleDialogState();
}

class _SpoilerV2EditTitleDialogState extends State<_SpoilerV2EditTitleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
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
      title: Text(widget.tr.spoilerV2EditTitle),
      content: Form(
        key: _formKey,
        child: TextFormField(
          focusNode: _focus,
          autofocus: true,
          controller: _controller,
          validator: (v) {
            if (v == null || v.isEmpty) {
              return widget.tr.spoilerV2EditTitleNotEmpty;
            }
            if (v.contains('[') || v.contains(']')) {
              return widget.tr.spoilerV2EditTitleInvalidTitle;
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
              Navigator.of(context).pop(_controller.text);
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
