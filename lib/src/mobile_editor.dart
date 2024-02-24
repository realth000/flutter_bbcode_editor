import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/constants.dart';

/// Editor used on mobile platforms.
///
/// Have toolbar.
final class MobileEditor extends StatefulWidget {
  /// Constructor.
  const MobileEditor({
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
  State<MobileEditor> createState() => _MobileEditorState();
}

final class _MobileEditorState extends State<MobileEditor> {
  late final EditorScrollController editorScrollController;
  late EditorStyle editorStyle;
  late Map<String, BlockComponentBuilder> blockComponentBuilders;
  late List<CommandShortcutEvent> commandShortcuts;

  /// Build the editor appearance including cursor style, colorscheme and more.
  EditorStyle _buildMobileEditorStyle() {
    final primaryColor = widget.themeData.colorScheme.primary;
    final secondaryColor = widget.themeData.colorScheme.secondary;

    return EditorStyle.mobile(
      cursorColor: primaryColor,
      dragHandleColor: primaryColor,
      selectionColor: secondaryColor,
      // textStyleConfiguration: TextStyleConfiguration(
      //      text: GoogleFonts.poppins(
      //        fontSize: 14,
      //        color: Colors.black,
      //      ),
      //      code: GoogleFonts.sourceCodePro(
      //        backgroundColor: Colors.grey.shade200,
      //      ),
      //     ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      magnifierSize: const Size(144, 96),
      mobileDragHandleBallSize: const Size(12, 12),
    );
  }

  // showcase 2: customize the block style
  Map<String, BlockComponentBuilder> _buildBlockComponentBuilders() {
    final map = {
      ...standardBlockComponentBuilderMap,
    };
    // TODO: Customize.
    const levelToFontSize = defaultLevelToFontSize;
    map[HeadingBlockKeys.type] = HeadingBlockComponentBuilder(
      textStyleBuilder: (level) => TextStyle(
        fontSize: levelToFontSize.elementAtOrNull(level - 1) ?? defaultFontSize,
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
    );

    editorStyle = _buildMobileEditorStyle();
    blockComponentBuilders = _buildBlockComponentBuilders();
  }

  @override
  void reassemble() {
    super.reassemble();

    editorStyle = _buildMobileEditorStyle();
    blockComponentBuilders = _buildBlockComponentBuilders();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      PlatformExtension.isMobile,
      'MobileEditor is only available on mobile platforms.',
    );
    return MobileToolbarV2(
      toolbarHeight: 48,
      toolbarItems: [
        textDecorationMobileToolbarItemV2,
        buildTextAndBackgroundColorMobileToolbarItem(),
        blocksMobileToolbarItem,
        linkMobileToolbarItem,
        dividerMobileToolbarItem,
      ],
      editorState: widget.editorState,
      child: Column(
        children: [
          Expanded(
            child: MobileFloatingToolbar(
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
                  onSelectAll: () =>
                      selectAllCommand.execute(widget.editorState),
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
                editorStyle: editorStyle,
                editorState: widget.editorState,
                editorScrollController: editorScrollController,
                blockComponentBuilders: blockComponentBuilders,
                showMagnifier: true,
                // header: Padding(
                //   padding: const EdgeInsets.only(bottom: 10),
                //   child: Image.asset(
                //     'assets/images/header.png',
                //   ),
                // ),
                footer: const SizedBox(
                  height: 100,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
