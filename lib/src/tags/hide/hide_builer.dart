import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/l10n/l10n_widget.dart';
import 'package:flutter_bbcode_editor/src/tags/hide/hide_embed.dart';
import 'package:flutter_bbcode_editor/src/tags/hide/hide_keys.dart';
import 'package:flutter_bbcode_editor/src/types.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

/// Editor widget builder for embed hide types.
///
/// Hide area is set to be invisible
final class BBCodeHideEmbedBuilder extends EmbedBuilder {
  /// Constructor.
  BBCodeHideEmbedBuilder({
    required BBCodeEmojiPicker emojiPicker,
    required BBCodeEmojiProvider emojiProvider,
    required BBCodeUrlLauncher urlLauncher,
    BBCodeColorPicker? colorPicker,
    BBCodeColorPicker? backgroundColorPicker,
    BBCodeUrlPicker? urlPicker,
    BBCodeImagePicker? imagePicker,
    BBCodeImageProvider? imageProvider,
    BBCodeUsernamePicker? usernamePicker,
    BBCodeUserMentionHandler? userMentionHandler,
  }) : _emojiPicker = emojiPicker,
       _colorPicker = colorPicker,
       _backgroundColorPicker = backgroundColorPicker,
       _urlPicker = urlPicker,
       _imagePicker = imagePicker,
       _imageProvider = imageProvider,
       _usernamePicker = usernamePicker,
       _emojiProvider = emojiProvider,
       _userMentionHandler = userMentionHandler,
       _urlLauncher = urlLauncher;

  final BBCodeEmojiPicker _emojiPicker;

  final BBCodeColorPicker? _colorPicker;
  final BBCodeColorPicker? _backgroundColorPicker;
  final BBCodeUrlPicker? _urlPicker;
  final BBCodeImagePicker? _imagePicker;
  final BBCodeImageProvider? _imageProvider;
  final BBCodeUsernamePicker? _usernamePicker;
  final BBCodeUserMentionHandler? _userMentionHandler;
  final BBCodeEmojiProvider _emojiProvider;
  final BBCodeUrlLauncher _urlLauncher;

  @override
  String get key => BBCodeHideKeys.type;

  @override
  bool get expanded => false;

  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: widget));
  }

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final info = BBCodeHideInfo.fromJson(embedContext.node.value.data as String);

    return _HideCard(
      onEdited: (info) {
        final offset = getEmbedNode(embedContext.controller, embedContext.controller.selection.start).offset;
        embedContext.controller
          ..replaceText(offset, 1, BBCodeHideEmbed(info), TextSelection.collapsed(offset: offset))
          ..moveCursorToPosition(offset + 1);
      },
      onTap:
          () =>
              embedContext.controller.moveCursorToPosition(embedContext.node.documentOffset + embedContext.node.length),
      initialData: info,
      emojiPicker: _emojiPicker,
      colorPicker: _colorPicker,
      backgroundColorPicker: _backgroundColorPicker,
      urlPicker: _urlPicker,
      imagePicker: _imagePicker,
      imageProvider: _imageProvider,
      usernamePicker: _usernamePicker,
      emojiProvider: _emojiProvider,
      userMentionHandler: _userMentionHandler,
      urlLauncher: _urlLauncher,
    );
  }
}

class _HideCard extends StatefulWidget {
  const _HideCard({
    required this.onEdited,
    required this.onTap,
    required this.initialData,
    required this.emojiPicker,
    required this.emojiProvider,
    required this.urlLauncher,
    this.userMentionHandler,
    this.colorPicker,
    this.backgroundColorPicker,
    this.urlPicker,
    this.imagePicker,
    this.imageProvider,
    this.usernamePicker,
  });

  /// Callback when hide content is edited.
  final void Function(BBCodeHideInfo) onEdited;

  /// See comments on _SpoilerCard.onTap
  final VoidCallback onTap;

  final BBCodeEmojiPicker emojiPicker;
  final BBCodeColorPicker? colorPicker;
  final BBCodeColorPicker? backgroundColorPicker;
  final BBCodeUrlPicker? urlPicker;
  final BBCodeImagePicker? imagePicker;
  final BBCodeImageProvider? imageProvider;
  final BBCodeUsernamePicker? usernamePicker;
  final BBCodeUserMentionHandler? userMentionHandler;
  final BBCodeEmojiProvider emojiProvider;
  final BBCodeUrlLauncher urlLauncher;

  /// For first screen rendering.
  final BBCodeHideInfo initialData;

  @override
  State<_HideCard> createState() => _HideCardState();
}

class _HideCardState extends State<_HideCard> {
  late BBCodeEditorController bodyController;

  /// Current carrying body data.
  ///
  /// The data here is only to save content from edit page and load content for
  /// edit page.
  late BBCodeHideInfo data;

  Future<void> editHide() async {
    final data = await Navigator.push<BBCodeHideInfo>(
      context,
      MaterialPageRoute(
        builder:
            (context) => BBCodeLocalizationsWidget(
              child: _HideEditPage(
                initialData: this.data,
                colorPicker: widget.colorPicker,
                backgroundColorPicker: widget.backgroundColorPicker,
                urlPicker: widget.urlPicker,
                imagePicker: widget.imagePicker,
                imageProvider: widget.imageProvider,
                usernamePicker: widget.usernamePicker,
                userMentionHandler: widget.userMentionHandler,
                emojiPicker: widget.emojiPicker,
                emojiProvider: widget.emojiProvider,
              ),
            ),
      ),
    );
    if (data != null) {
      setState(() {
        this.data = data;
        bodyController.setDocumentFromJson(jsonDecode(data.body) as List<dynamic>);
      });
      // Call the callback to save data in embed builder, otherwise when
      // the builder called next time, data will reset to default.
      widget.onEdited(data);
    }
  }

  Future<void> copyQuillDelta() async {
    final quillDelta = bodyController.toQuillDelta();
    await Clipboard.setData(ClipboardData(text: quillDelta));
  }

  Future<void> copyBBCode() async {
    final bbcode = bodyController.toBBCode();
    await Clipboard.setData(ClipboardData(text: bbcode));
  }

  Widget buildDialog(BuildContext context) {
    final tr = context.bbcodeL10n;
    return AlertDialog(
      title: Text(tr.hide),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(tr.edit),
            onTap: () async {
              Navigator.pop(context);
              await editHide();
            },
          ),
          ListTile(
            leading: const Icon(Icons.copy_outlined),
            title: Text(tr.copyQuilDelta),
            onTap: () async {
              await copyQuillDelta();
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.copy_all_outlined),
            title: Text(tr.copyBBCode),
            onTap: () async {
              await copyBBCode();
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final tr = context.bbcodeL10n;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.lock_outline, color: primaryColor),
        const SizedBox(width: 8),
        Text(tr.hide, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: primaryColor)),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    bodyController = buildBBCodeEditorController(readOnly: true);
    data = widget.initialData;
    // Because the card may be frequently built when user add content above the
    // current spoiler, each rebuild will construct a different card state,
    // sync the content data in last card state to current state's controller.
    // This fixes card content become empty when user add new paragraph above
    // the current spoiler.
    if (data.body.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          bodyController.setDocumentFromDelta(Delta.fromJson(jsonDecode(data.body) as List<dynamic>));
        });
      });
    }
  }

  @override
  void dispose() {
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.bbcodeL10n;

    return GestureDetector(
      onTap: () async {
        widget.onTap.call();
        await showDialog<void>(context: context, builder: (_) => buildDialog(context));
      },
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildToolbar(context),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    if (data.points > 0) ...[
                      TextSpan(text: tr.hideWithPointsOuterHead),
                      TextSpan(text: '${data.points}'),
                      TextSpan(text: tr.hideWithPointsOuterTail),
                    ] else
                      TextSpan(text: tr.hideWithReplyOuter),
                  ],
                ),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 8),
              BBCodeEditor(
                controller: bodyController,
                // TODO: Implement it.
                emojiProvider: widget.emojiProvider,
                emojiPicker: widget.emojiPicker,
                colorPicker: widget.colorPicker,
                backgroundColorPicker: widget.backgroundColorPicker,
                urlPicker: widget.urlPicker,
                imageProvider: widget.imageProvider,
                imagePicker: widget.imagePicker,
                userMentionHandler: widget.userMentionHandler,
                urlLauncher: widget.urlLauncher,
                usernamePicker: widget.usernamePicker,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Page to edit a spoiler card.
///
/// Currently it's different to implement a spoiler with inline edit support as
/// the outer editor and inner editor share unwanted data attributes.
///
/// The only way seems work is pushing to another page, providing all
/// functionality, redirect back and update content if changed.
///
/// This is the temporary page.
class _HideEditPage extends StatefulWidget {
  const _HideEditPage({
    required this.initialData,
    required this.emojiPicker,
    required this.emojiProvider,
    required this.imageProvider,
    this.userMentionHandler,
    this.colorPicker,
    this.backgroundColorPicker,
    this.urlPicker,
    this.imagePicker,
    this.usernamePicker,
  });

  final BBCodeEmojiPicker emojiPicker;
  final BBCodeColorPicker? colorPicker;
  final BBCodeColorPicker? backgroundColorPicker;
  final BBCodeUrlPicker? urlPicker;
  final BBCodeImagePicker? imagePicker;
  final BBCodeImageProvider? imageProvider;
  final BBCodeUsernamePicker? usernamePicker;
  final BBCodeEmojiProvider emojiProvider;
  final BBCodeUserMentionHandler? userMentionHandler;

  /// Optional initial data to show.
  final BBCodeHideInfo? initialData;

  @override
  State<_HideEditPage> createState() => _HideEditPageState();
}

enum _HideWithType { points, reply }

class _HideEditPageState extends State<_HideEditPage> {
  late TextEditingController pointsController;
  late BBCodeEditorController bodyController;

  late _HideWithType withType;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final pv = widget.initialData?.points;
    pointsController = TextEditingController(text: pv == null || pv <= 0 ? '' : '${widget.initialData?.points}');
    withType = switch (pv) {
      null || <= 0 => _HideWithType.reply,
      _ => _HideWithType.points,
    };
    bodyController = buildBBCodeEditorController();
    if (widget.initialData != null && widget.initialData!.body.isNotEmpty) {
      bodyController.setDocumentFromDelta(Delta.fromJson(jsonDecode(widget.initialData!.body) as List<dynamic>));
    }
  }

  @override
  void dispose() {
    pointsController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.bbcodeL10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(tr.spoilerEditPageTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: () async {
              if (withType == _HideWithType.points && !(formKey.currentState?.validate() ?? true)) {
                return;
              }

              Navigator.pop(
                context,
                BBCodeHideInfo(
                  points: switch (withType) {
                    _HideWithType.points => int.parse(pointsController.text),
                    _HideWithType.reply => -1,
                  },
                  body: bodyController.toQuillDelta(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            RadioListTile(
              title: Text(tr.hideWithReply),
              subtitle: Text(tr.hideWithReplyDetail),
              value: _HideWithType.reply,
              groupValue: withType,
              onChanged: (v) {
                if (v == null) {
                  return;
                }
                setState(() {
                  withType = v;
                });
              },
            ),
            RadioListTile(
              title: Text(tr.hideWithPoints),
              subtitle: Text(tr.hideWithPointsDetail),
              value: _HideWithType.points,
              groupValue: withType,
              onChanged: (v) {
                if (v == null) {
                  return;
                }
                setState(() {
                  withType = v;
                });
              },
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 100),
              child:
                  withType == _HideWithType.points
                      ? Row(
                        children: [
                          const SizedBox(width: 48),
                          Expanded(
                            child: Form(
                              key: formKey,
                              child: TextFormField(
                                controller: pointsController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(labelText: tr.hidePoints),
                                validator: (v) {
                                  final vv = int.tryParse(v ?? '');
                                  if (vv == null || vv <= 0) {
                                    return tr.hidePointsInvalid;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                      : const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BBCodeEditor(
                autoFocus: true,
                controller: bodyController,
                emojiProvider: widget.emojiProvider,
                emojiPicker: widget.emojiPicker,
                imageProvider: widget.imageProvider,
                colorPicker: widget.colorPicker,
                backgroundColorPicker: widget.backgroundColorPicker,
                urlPicker: widget.urlPicker,
                imagePicker: widget.imagePicker,
                userMentionHandler: widget.userMentionHandler,
                usernamePicker: widget.usernamePicker,
              ),
            ),
            BBCodeEditorToolbar(
              controller: bodyController,
              config: const BBCodeEditorToolbarConfiguration(),
              emojiPicker: widget.emojiPicker,
              colorPicker: widget.colorPicker,
              backgroundColorPicker: widget.backgroundColorPicker,
              urlPicker: widget.urlPicker,
              imagePicker: widget.imagePicker,
              usernamePicker: widget.usernamePicker,
              // Disable font family
              showFontFamily: false,
              // Disable nested hide
              showHideButton: false,
            ),
          ],
        ),
      ),
    );
  }
}
