part of 'editor.dart';

/// Representing user pick color result.
///
/// * Picked.
/// * Canceled.
/// * Request to clear color.
final class PickColorResult {
  /// User picked a color.
  PickColorResult.picked(Color this.color) : clearColor = false;

  /// User requested to clear color.
  PickColorResult.clearColor()
      : color = null,
        clearColor = true;

  /// User cancel the pick.
  PickColorResult.canceled()
      : color = null,
        clearColor = false;

  /// Color to apply.
  Color? color;

  /// Need to clear color.
  bool clearColor;

  /// Check the result is canceled or not.
  bool get isCanceled => color == null && !clearColor;
}

/// Function to pick and return a color.
///
/// ## Return
///
/// * Color: Nullable color. Return the color if user picked.
/// * bool
typedef BBCodeColorPicker = Future<PickColorResult> Function(
  BuildContext context,
);

/// Result in picking url.
///
/// Contains [url] and optional [description].
final class PickUrlResult {
  /// Constructor.
  const PickUrlResult({required this.url, required this.description});

  /// Url, http or https.
  ///
  /// Support both have scheme ant not.
  /// Without scheme will later prepend a predefined host.
  final String url;

  /// Optional link description.
  final String? description;
}

/// Function to pick an url.
///
///
typedef BBCodeUrlPicker = Future<PickUrlResult?> Function(BuildContext context);

/// Toolbar of the editor.
class BBCodeEditorToolbar extends StatefulWidget {
  /// Constructor.
  const BBCodeEditorToolbar({
    required BBCodeEditorController controller,
    required BBCodeEditorToolbarConfiguration config,
    required BBCodeEmojiPicker emojiPicker,
    this.focusNode,
    BBCodeColorPicker? colorPicker,
    BBCodeColorPicker? backgroundColorPicker,
    BBCodeUrlPicker? urlPicker,
    String? host,
    super.key,
  })  : _controller = controller,
        _config = config,
        _emojiPicker = emojiPicker,
        _colorPicker = colorPicker,
        _backgroundColorPicker = backgroundColorPicker,
        _urlPicker = urlPicker,
        _host = host;

  final BBCodeEditorController _controller;

  final BBCodeEditorToolbarConfiguration _config;

  final FocusNode? focusNode;

  final BBCodeEmojiPicker _emojiPicker;

  final BBCodeColorPicker? _colorPicker;
  final BBCodeColorPicker? _backgroundColorPicker;
  final BBCodeUrlPicker? _urlPicker;

  /// Host of site.
  ///
  /// Used in picking urls if url does not contain a host.
  final String? _host;

  @override
  State<BBCodeEditorToolbar> createState() => _BBCodeEditorToolbarState();
}

class _BBCodeEditorToolbarState extends State<BBCodeEditorToolbar> {
  late final BBCodeEditorController controller;

  late final QuillToolbarColorButtonOptions colorButtonOptions;
  late final QuillToolbarColorButtonOptions backgroundColorButtonOptions;
  late final QuillToolbarLinkStyleButtonOptions urlButtonOptions;

  /// Refer: flutter_quill/lib/src/widgets/toolbar/color/color_button.dart
  void _changeColor(
    BuildContext context,
    QuillController controller,
    bool isBackground,
    Color? color,
  ) {
    if (color == null) {
      controller.formatSelection(
        isBackground
            ? const BackgroundAttribute(null)
            : const ColorAttribute(null),
      );
      return;
    }
    var hex = colorToHex(color);
    hex = '#$hex';
    controller.formatSelection(
      isBackground ? BackgroundAttribute(hex) : ColorAttribute(hex),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = widget._controller;
    if (widget._colorPicker != null) {
      colorButtonOptions = QuillToolbarColorButtonOptions(
        customOnPressedCallback: (controller, isBackground) async {
          final pickResult = await widget._colorPicker!(context);
          if (pickResult.isCanceled || !mounted) {
            return;
          }

          if (pickResult.clearColor) {
            _changeColor(context, controller, false, null);
          } else {
            _changeColor(context, controller, false, pickResult.color);
          }
        },
      );
    } else {
      colorButtonOptions = const QuillToolbarColorButtonOptions();
    }
    if (widget._backgroundColorPicker != null) {
      backgroundColorButtonOptions = QuillToolbarColorButtonOptions(
        customOnPressedCallback: (controller, isBackground) async {
          final pickResult = await widget._backgroundColorPicker!(context);
          if (pickResult.isCanceled || !mounted) {
            return;
          }

          if (pickResult.clearColor) {
            _changeColor(context, controller, true, null);
          } else {
            _changeColor(context, controller, true, pickResult.color);
          }
        },
      );
    } else {
      backgroundColorButtonOptions = const QuillToolbarColorButtonOptions();
    }

    if (widget._urlPicker != null) {
      urlButtonOptions = QuillToolbarLinkStyleButtonOptions(
        customOnPressedCallback: (controller) async {
          final urlResult = await widget._urlPicker!(context);
          if (urlResult == null) {
            return;
          }
          final description = urlResult.description ?? urlResult.url;
          // Prepend host only if:
          //
          // * Host not null.
          // * Url does not have host.
          final url = widget._host != null &&
                  !urlResult.url.startsWith('http://') &&
                  !urlResult.url.startsWith('https://')
              ? '${widget._host}/${urlResult.url}'
              : urlResult.url;

          QuillTextLink(description, url).submit(controller);
        },
      );
    } else {
      urlButtonOptions = const QuillToolbarLinkStyleButtonOptions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BBCodeLocalizationsWidget(
      child: QuillToolbar.simple(
        configurations: QuillSimpleToolbarConfigurations(
          controller: controller._quillController,
          // Below are all formats implemented in quill but not supported in
          // TSDM.
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

          buttonOptions: QuillSimpleToolbarButtonOptions(
            color: colorButtonOptions,
            backgroundColor: backgroundColorButtonOptions,
            linkStyle: urlButtonOptions,
          ),

          // embedButtons: FlutterQuillEmbeds.toolbarButtons(),
          embedButtons: [
            (controller, toolbarIconSize, iconTheme, dialogTheme) =>
                // FIXME: Do not add l10n here.
                BBCodeLocalizationsWidget(
                  child: BBCodeEditorToolbarImageButton(
                    controller: widget._controller,
                  ),
                ),
            (controller, toolbarIconSize, iconTheme, dialogTheme) =>
                BBCodeLocalizationsWidget(
                  child: BBCodeEditorToolbarEmojiButton(
                    controller: widget._controller,
                    emojiPicker: widget._emojiPicker,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
