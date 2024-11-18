import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/tags/spoiler/spoiler_embed.dart';
import 'package:flutter_bbcode_editor/src/tags/spoiler/spoiler_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Editor widget builder for embed spoiler types.
///
/// Spoiler is an expandable area contains title on and body.
final class BBCodeSpoilerEmbedBuilder extends EmbedBuilder {
  /// Constructor.
  BBCodeSpoilerEmbedBuilder();

  @override
  String get key => BBCodeSpoilerKeys.type;

  @override
  bool get expanded => false;

  @override
  WidgetSpan buildWidgetSpan(Widget widget) {
    return WidgetSpan(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
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
    return _SpoilerCard(info);
  }
}

class _SpoilerCard extends StatefulWidget {
  const _SpoilerCard(this.initialData);

  /// For first screen rendering.
  final BBCodeSpoilerInfo initialData;

  @override
  State<_SpoilerCard> createState() => _SpoilerCardState();
}

class _SpoilerCardState extends State<_SpoilerCard> {
  final bodyController = BBCodeEditorController(readOnly: true);

  /// Current carrying body data.
  late BBCodeSpoilerInfo bodyData;

  /// Flag indicating body is visible or not.
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    bodyData = widget.initialData;
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SpoilerEditorToolbar(bodyController),
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
                initialText: bodyData.toString(),
                controller: bodyController,
                // TODO: Implement it.
                emojiProvider: (_, __) => const FlutterLogo(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Toolbar of the spoiler editor.
class _SpoilerEditorToolbar extends StatelessWidget {
  const _SpoilerEditorToolbar(this.controller);

  /// Injected bbcodeEditorController.
  final BBCodeEditorController controller;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final tr = context.bbcodeL10n;
    return Row(
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
          onPressed: () {
            throw UnimplementedError();
          },
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.copy_outlined),
          tooltip: tr.spoilerCopyQuilDelta,
          onPressed: () async {
            final quillDelta = controller.toQuillDelta();
            await Clipboard.setData(ClipboardData(text: quillDelta));
          },
        ),
        IconButton(
          icon: const Icon(Icons.copy_all_outlined),
          tooltip: tr.spoilerCopyBBCode,
          onPressed: () async {
            final bbcode = controller.toBBCode();
            await Clipboard.setData(ClipboardData(text: bbcode));
          },
        ),
        // const SizedBox(width: 4),
        // TODO: implement delete action.
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
}
