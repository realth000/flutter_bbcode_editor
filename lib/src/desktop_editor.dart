import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/basic_editor.dart';
import 'package:flutter_bbcode_editor/src/constants.dart';
import 'package:flutter_bbcode_editor/src/text_span_decorator.dart';
import 'package:flutter_bbcode_editor/src/utils.dart';

/// Editor used on desktop platforms.
///
/// Have floating context menu, handle text click events and more.
final class DesktopEditor extends BasicEditor {
  /// Constructor.
  const DesktopEditor({
    required super.editorState,
    required super.emojiBuilder,
    required super.imageBuilder,
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
  State<BasicEditor> createState() => _DesktopEditorState();
}

final class _DesktopEditorState extends BasicEditorState {
  late final EditorScrollController editorScrollController;
  late Map<String, BlockComponentBuilder> blockComponentBuilders;

  List<CommandShortcutEvent>? commandShortcuts;

  /// All shortcut event triggered by single character.
  ///
  /// For example, show the slash context menu when user entered "/".
  ///
  /// For default standard shortcuts, see [standardCharacterShortcutEvents].
  List<CharacterShortcutEvent>? characterShortcuts;

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
      textSpanDecorator: widget.bbcodeInlineComponentBuilder,
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
    const levelToFontSize = defaultLevelToFontSizeMap;

    map[HeadingBlockKeys.type] = HeadingBlockComponentBuilder(
      textStyleBuilder: (level) => TextStyle(
        fontSize: levelToFontSize[level] ?? defaultFontSize,
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

  /// We only use some of the [standardCharacterShortcutEvents], disabled many
  /// events for stability and make the editor easy to use.
  ///
  /// Note that the default events offers markdown syntax support, disable them
  /// for now and make optional in future.
  List<CharacterShortcutEvent> _buildCharacterShortcutEvents() {
    return [
      // '\n'
      // Insert new line.
      insertNewLine,
      insertNewLineAfterBulletedList,
      insertNewLineAfterNumberedList,
      insertNewLineAfterHeading,

      // bulleted list
      formatAsteriskToBulletedList,
      formatMinusToBulletedList,

      // numbered list
      formatNumberToNumberedList,

      // heading
      formatSignToHeading,
    ];
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
    characterShortcuts ??= _buildCharacterShortcutEvents();
    assert(
      PlatformExtension.isDesktopOrWeb,
      'DesktopEditor is only available on Desktop or Web platforms.',
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: AppFlowyEditor(
        autoFocus: widget.autoFocus,
        focusNode: widget.focusNode,
        editorState: widget.editorState,
        editorScrollController: editorScrollController,
        blockComponentBuilders: blockComponentBuilders,
        characterShortcutEvents: characterShortcuts,
        commandShortcutEvents: commandShortcuts,
        editorStyle: _buildDesktopEditorStyle(context),
      ),
    );
  }
}
