import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/basic_editor.dart';
import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/utils.dart';

/// Editor used on desktop platforms.
///
/// Have floating context menu, handle text click events and more.
final class DesktopEditor extends BasicEditor {
  /// Constructor.
  const DesktopEditor({
    required super.editorState,
    super.controller,
    super.key,
  });

  @override
  State<BasicEditor> createState() => _DesktopEditorState();
}

final class _DesktopEditorState extends BasicEditorState {
  late final EditorScrollController editorScrollController;
  late Map<String, BlockComponentBuilder> blockComponentBuilders;
  List<CommandShortcutEvent>? commandShortcuts;

  /// Build the editor appearance including cursor style, colorscheme and more.
  EditorStyle _buildDesktopEditorStyle(BuildContext context) {
    final selectionColor = switch (MediaQuery.of(context).platformBrightness) {
      Brightness.light =>
        Theme.of(context).colorScheme.primaryContainer.brighten(),
      Brightness.dark =>
        Theme.of(context).colorScheme.primaryContainer.darken(),
    };

    return EditorStyle.desktop(
      cursorWidth: 2.1,
      cursorColor: Theme.of(context).colorScheme.primary,
      selectionColor: selectionColor,
      padding: EdgeInsets.zero,
      textStyleConfiguration: TextStyleConfiguration(
        text: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white,
        ),
      ),
    );
  }

  Map<String, BlockComponentBuilder> _buildBlockComponentBuilders() {
    final map = {
      ...standardBlockComponentBuilderMap,
    };

    map[ImageBlockKeys.type] = ImageBlockComponentBuilder(
      showMenu: true,
      menuBuilder: (node, _) {
        return const Positioned(
          right: 10,
          child: Text('image block component menu'),
        );
      },
    );

    // TODO: Customize.
    // Font size for every header level.
    // This is sync with the default font size on server side.
    const levelToFontSize = defaultLevelToFontSize;

    map[HeadingBlockKeys.type] = HeadingBlockComponentBuilder(
      textStyleBuilder: (level) => TextStyle(
        fontSize: levelToFontSize.elementAtOrNull(level - 1) ?? defaultFontSize,
        fontWeight: defaultHeaderFontWeight,
      ),
    );
    map.forEach((k, v) {
      v.configuration = v.configuration.copyWith(
        padding: (_) => const EdgeInsets.symmetric(vertical: 8),
      );
    });
    return map;
  }

  List<CommandShortcutEvent> _buildCommandShortcuts() {
    return [
      customToggleHighlightCommand(
        style: ToggleColorsStyle(
          highlightColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
      ...[
        ...standardCommandShortcutEvents
          ..removeWhere(
            (el) => el == toggleHighlightCommand,
          ),
      ],
      // TODO: I18n
      ...findAndReplaceCommands(
        context: context,
        localizations: FindReplaceLocalizations(
          find: 'Find',
          previousMatch: 'Previous match',
          nextMatch: 'Next match',
          close: 'Close',
          replace: 'Replace',
          replaceAll: 'Replace all',
          noResult: 'No result',
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    editorScrollController = EditorScrollController(
      editorState: widget.editorState,
    );
    blockComponentBuilders = _buildBlockComponentBuilders();
  }

  @override
  void dispose() {
    super.dispose();
    editorScrollController.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    blockComponentBuilders = _buildBlockComponentBuilders();
  }

  @override
  Widget build(BuildContext context) {
    commandShortcuts ??= _buildCommandShortcuts();
    assert(
      PlatformExtension.isDesktopOrWeb,
      'DesktopEditor is only available on Desktop or Web platforms.',
    );

    return FloatingToolbar(
      textDirection: TextDirection.ltr,
      items: [
        paragraphItem,
        ...headingItems,
        ...markdownFormatItems,
        quoteItem,
        bulletedListItem,
        numberedListItem,
        linkItem,
        buildTextColorItem(),
        buildHighlightColorItem(),
        ...textDirectionItems,
        ...alignmentItems,
      ],
      editorState: widget.editorState,
      editorScrollController: editorScrollController,
      style: FloatingToolbarStyle(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        toolbarActiveColor: Theme.of(context).colorScheme.primary,
        toolbarIconColor: Theme.of(context).colorScheme.secondary,
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: Theme.of(context).colorScheme.surface,
          child: AppFlowyEditor(
            editorState: widget.editorState,
            editorScrollController: editorScrollController,
            blockComponentBuilders: blockComponentBuilders,
            commandShortcutEvents: commandShortcuts,
            editorStyle: _buildDesktopEditorStyle(context),
            footer: const SizedBox(
              height: 100,
            ),
          ),
        ),
      ),
    );
  }
}
