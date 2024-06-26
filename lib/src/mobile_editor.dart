import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/basic_editor.dart';
import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/text_span_decorator.dart';
import 'package:flutter_bbcode_editor/src/utils.dart';

/// Editor used on mobile platforms.
///
/// Have toolbar.
final class MobileEditor extends BasicEditor {
  /// Constructor.
  const MobileEditor({
    required super.editorState,
    super.emojiBuilder,
    super.imageBuilder,
    super.urlLauncher,
    super.urlTextStyle,
    super.mentionUserLauncher,
    super.controller,
    super.scrollController,
    super.focusNode,
    super.autoFocus,
    super.key,
  });

  @override
  State<BasicEditor> createState() => _MobileEditorState();
}

final class _MobileEditorState extends BasicEditorState {
  late final EditorScrollController editorScrollController;
  late Map<String, BlockComponentBuilder> blockComponentBuilders;
  List<CommandShortcutEvent>? commandShortcuts;

  /// Build the editor appearance including cursor style, colorscheme and more.
  EditorStyle _buildMobileEditorStyle(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final selectionColor = switch (MediaQuery.of(context).platformBrightness) {
      Brightness.light =>
        Theme.of(context).colorScheme.primaryContainer.brighten(),
      Brightness.dark =>
        Theme.of(context).colorScheme.primaryContainer.darken(),
    };

    return EditorStyle.mobile(
      cursorWidth: 2.1,
      cursorColor: Theme.of(context).colorScheme.primary,
      dragHandleColor: primaryColor,
      selectionColor: selectionColor,
      padding: EdgeInsets.zero,
      magnifierSize: const Size(144, 96),
      mobileDragHandleBallSize: const Size(12, 12),
      textStyleConfiguration: TextStyleConfiguration(
        text: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white,
        ),
      ),
      textSpanDecorator: widget.bbcodeInlineComponentBuilder,
    );
  }

  // showcase 2: customize the block style
  Map<String, BlockComponentBuilder> _buildBlockComponentBuilders() {
    final map = {
      ...standardBlockComponentBuilderMap,
    };
    // TODO: Customize.
    const levelToFontSize = defaultLevelToFontSizeMap;
    map[HeadingBlockKeys.type] = HeadingBlockComponentBuilder(
      textStyleBuilder: (level) => TextStyle(
        fontSize: levelToFontSize[level] ?? defaultFontSize,
        fontWeight: defaultHeaderFontWeight,
      ),
    );
    map[ParagraphBlockKeys.type] = ParagraphBlockComponentBuilder(
      configuration: BlockComponentConfiguration(
        placeholderText: (node) => 'Type something...',
      ),
    );
    return map;
  }

  @override
  void initState() {
    super.initState();
    editorScrollController = EditorScrollController(
      editorState: widget.editorState,
      scrollController: widget.scrollController,
    );

    blockComponentBuilders = _buildBlockComponentBuilders();
  }

  @override
  void dispose() {
    editorScrollController.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    blockComponentBuilders = _buildBlockComponentBuilders();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      PlatformExtension.isMobile,
      'MobileEditor is only available on mobile platforms.',
    );
    return MobileFloatingToolbar(
      editorState: widget.editorState,
      editorScrollController: editorScrollController,
      toolbarBuilder: (context, anchor, closeToolbar) {
        return AdaptiveTextSelectionToolbar.editable(
          clipboardStatus: ClipboardStatus.pasteable,
          onCopy: () {
            copyCommand.execute(widget.editorState);
            closeToolbar();
          },
          onCut: () => cutCommand.execute(widget.editorState),
          onPaste: () => pasteCommand.execute(widget.editorState),
          onSelectAll: () => selectAllCommand.execute(widget.editorState),
          onLiveTextInput: null,
          onLookUp: null,
          onSearchWeb: null,
          onShare: null,
          anchors: TextSelectionToolbarAnchors(
            primaryAnchor: anchor,
          ),
        );
      },
      child: AppFlowyEditor(
        autoFocus: widget.autoFocus,
        focusNode: widget.focusNode,
        editorStyle: _buildMobileEditorStyle(context),
        editorState: widget.editorState,
        editorScrollController: editorScrollController,
        blockComponentBuilders: blockComponentBuilders,
      ),
    );
  }
}
