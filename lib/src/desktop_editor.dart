import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/constants.dart';

/// Editor used on desktop platforms.
///
/// Have floating context menu, handle text click events and more.
class DesktopEditor extends StatefulWidget {
  /// Constructor.
  const DesktopEditor({
    required this.editorState,
    required this.themeData,
    super.key,
  });

  /// The state of editor.
  final EditorState editorState;

  /// Theme of editor.
  ///
  /// Required because we can not access context during init state.
  final ThemeData themeData;

  @override
  State<DesktopEditor> createState() => _DesktopEditorState();
}

final class _DesktopEditorState extends State<DesktopEditor> {
  late final EditorScrollController editorScrollController;
  late EditorStyle editorStyle;
  late Map<String, BlockComponentBuilder> blockComponentBuilders;
  late List<CommandShortcutEvent> commandShortcuts;

  /// Build the editor appearance including cursor style, colorscheme and more.
  EditorStyle _buildDesktopEditorStyle() {
    return EditorStyle.desktop(
      cursorWidth: 2.1,
      cursorColor: widget.themeData.colorScheme.primary,
      selectionColor: widget.themeData.colorScheme.primary,
      padding: EdgeInsets.zero,
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
          highlightColor: widget.themeData.colorScheme.secondary,
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
    editorStyle = _buildDesktopEditorStyle();
    blockComponentBuilders = _buildBlockComponentBuilders();
    commandShortcuts = _buildCommandShortcuts();
  }

  @override
  void reassemble() {
    super.reassemble();

    editorStyle = _buildDesktopEditorStyle();
    blockComponentBuilders = _buildBlockComponentBuilders();
  }

  @override
  Widget build(BuildContext context) {
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
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: AppFlowyEditor(
          editorState: widget.editorState,
          editorScrollController: editorScrollController,
          blockComponentBuilders: blockComponentBuilders,
          commandShortcutEvents: commandShortcuts,
          editorStyle: editorStyle,
          //header: Padding(
          //  padding: const EdgeInsets.only(bottom: 10),
          //  child: Image.asset(
          //    'assets/images/header.png',
          //    fit: BoxFit.fitWidth,
          //    height: 150,
          //  ),
          //),
          footer: const SizedBox(
            height: 100,
          ),
        ),
      ),
    );
  }
}
