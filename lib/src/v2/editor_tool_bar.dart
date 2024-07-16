part of 'editor.dart';

/// Toolbar of the editor.
class BBCodeEditorToolbar extends StatefulWidget {
  /// Constructor.
  const BBCodeEditorToolbar({
    required BBCodeEditorController controller,
    required BBCodeEditorToolbarConfiguration config,
    super.key,
  })  : _controller = controller,
        _config = config;

  final BBCodeEditorController _controller;

  final BBCodeEditorToolbarConfiguration _config;

  @override
  State<BBCodeEditorToolbar> createState() => _BBCodeEditorToolbarState();
}

class _BBCodeEditorToolbarState extends State<BBCodeEditorToolbar> {
  late final BBCodeEditorController controller;

  @override
  void initState() {
    super.initState();
    controller = widget._controller;
  }

  @override
  Widget build(BuildContext context) {
    return BBCodeLocalizationsWidget(
      child: QuillToolbar.simple(
        configurations: QuillSimpleToolbarConfigurations(
          controller: controller._quillController,
          // Below are all formats implemented in quill but not supported in TSDM.
          // These formats are disabled on default.
          //
          // Font family are not fixed to what quill supports.
          // Should let developer support it.
          // showFontFamily: false,
          // Use font size instead.
          showHeaderStyle: false,
          showInlineCode: false,
          showListCheck: false,
          showIndent: false,
          showSearchButton: false,
          showSubscript: false,
          fontSizesValues: defaultFontSizeMap,
          showAlignmentButtons: true,
          showJustifyAlignment: false,

          //
          fontFamilyValues: widget._config.fontFamilyValues,

          // embedButtons: FlutterQuillEmbeds.toolbarButtons(),
          embedButtons: [
            (controller, toolbarIconSize, iconTheme, dialogTheme) =>
                // FIXME: Do not add l10n here.
                BBCodeLocalizationsWidget(
                  child: BBCodeEditorToolbarImageButton(
                    controller: widget._controller,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
