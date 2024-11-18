import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/l10n/l10n_widget.dart';
import 'package:flutter_bbcode_editor/src/tags/spoiler/spoiler_embed.dart';
import 'package:flutter_bbcode_editor/src/tags/spoiler/spoiler_keys.dart';
import 'package:flutter_bbcode_editor/src/types.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Editor widget builder for embed spoiler types.
///
/// Spoiler is an expandable area contains title on and body.
final class BBCodeSpoilerEmbedBuilder extends EmbedBuilder {
  /// Constructor.
  BBCodeSpoilerEmbedBuilder({
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
  })  : _emojiPicker = emojiPicker,
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
  String get key => BBCodeSpoilerKeys.type;

  @override
  bool get expanded => false;

  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: widget,
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final info = BBCodeSpoilerInfo.fromJson(node.value.data as String);
    return _SpoilerCard(
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

class _SpoilerCard extends StatefulWidget {
  const _SpoilerCard({
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
  final BBCodeSpoilerInfo initialData;

  @override
  State<_SpoilerCard> createState() => _SpoilerCardState();
}

class _SpoilerCardState extends State<_SpoilerCard> {
  late BBCodeEditorController bodyController;

  /// Current carrying body data.
  late BBCodeSpoilerInfo data;

  /// Flag indicating body is visible or not.
  bool _visible = false;

  Widget _buildToolbar(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final tr = context.bbcodeL10n;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.expand_outlined, color: primaryColor),
        const SizedBox(width: 8),
        Text(
          context.bbcodeL10n.spoiler,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: primaryColor,
              ),
        ),
        const SizedBox(width: 24),
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          tooltip: tr.spoilerEdit,
          onPressed: () async {
            final data = await Navigator.push<BBCodeSpoilerInfo>(
              context,
              MaterialPageRoute(
                builder: (context) => BBCodeLocalizationsWidget(
                  child: _SpoilerEditPage(
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
                bodyController.setDocumentFromJson(
                  jsonDecode(data.body) as List<dynamic>,
                );
              });
            }
          },
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.copy_outlined),
          tooltip: tr.spoilerCopyQuilDelta,
          onPressed: () async {
            final quillDelta = bodyController.toQuillDelta();
            await Clipboard.setData(ClipboardData(text: quillDelta));
          },
        ),
        IconButton(
          icon: const Icon(Icons.copy_all_outlined),
          tooltip: tr.spoilerCopyBBCode,
          onPressed: () async {
            final bbcode = bodyController.toBBCode();
            await Clipboard.setData(ClipboardData(text: bbcode));
          },
        ),
        // TODO: implement delete action.
        // const SizedBox(width: 4),
        // IconButton(
        //   icon: Icon(
        //     Icons.delete_outline,
        //     color: Theme.of(context).colorScheme.error,
        //   ),
        //   tooltip: tr.spoilerDelete,
        //   onPressed: () {
        //   },
        // ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    bodyController = BBCodeEditorController(readOnly: true);
    data = widget.initialData;
  }

  @override
  void dispose() {
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.bbcodeL10n;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildToolbar(context),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              icon: _visible
                  ? const Icon(Icons.expand_less_outlined)
                  : const Icon(Icons.expand_more_outlined),
              label: Text(_visible ? tr.spoilerCollapse : tr.spoilerExpand),
              onPressed: () {
                setState(() {
                  _visible = !_visible;
                });
              },
            ),
            if (_visible) ...[
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
          ],
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
class _SpoilerEditPage extends StatefulWidget {
  const _SpoilerEditPage({
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
  final BBCodeSpoilerInfo? initialData;

  @override
  State<_SpoilerEditPage> createState() => _SpoilerEditPageState();
}

class _SpoilerEditPageState extends State<_SpoilerEditPage> {
  late TextEditingController titleController;
  late BBCodeEditorController bodyController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialData?.title);
    bodyController = BBCodeEditorController();
  }

  @override
  void dispose() {
    titleController.dispose();
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
            onPressed: () async => Navigator.pop(
              context,
              BBCodeSpoilerInfo(
                title: titleController.text,
                body: bodyController.toQuillDelta(),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: tr.spoilerEditPageOuter),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BBCodeEditor(
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
            ),
          ],
        ),
      ),
    );
  }
}
