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
  PickColorResult.clearColor() : color = null, clearColor = true;

  /// Color to apply.
  Color? color;

  /// Need to clear color.
  bool clearColor;
}

/// Function to pick and return a color.
///
/// ## Return
/// * [PickColorResult.picked] if any color picked.
/// * [PickColorResult.clearColor] if user requested to clear color.
/// * `null` if pick progress canceled.
typedef BBCodeColorPicker = Future<PickColorResult?> Function(BuildContext context, Color? initialColor);

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
typedef BBCodeUrlPicker = Future<PickUrlResult?> Function(BuildContext context, String? url, String? description);

/// Toolbar of the editor.
class BBCodeEditorToolbar extends StatefulWidget {
  /// Constructor.
  const BBCodeEditorToolbar({
    required BBCodeEditorController controller,
    required BBCodeEditorToolbarConfiguration config,
    required BBCodeEmojiPicker emojiPicker,
    BBCodeColorPicker? colorPicker,
    BBCodeColorPicker? backgroundColorPicker,
    BBCodeUrlPicker? urlPicker,
    BBCodeImagePicker? imagePicker,
    BBCodeUsernamePicker? usernamePicker,
    String? host,
    this.showUndo = true,
    this.showRedo = true,
    this.showFontFamily = true,
    this.showFontSize = true,
    this.showBoldButton = true,
    this.showItalicButton = true,
    this.showUnderlineButton = true,
    this.showStrikethroughButton = true,
    this.showSuperscriptButton = true,
    this.showColorButton = true,
    this.showBackgroundColorButton = true,
    this.showClearFormatButton = true,
    this.showImageButton = true,
    this.showEmojiButton = true,
    this.showLeftAlignButton = true,
    this.showCenterAlignButton = true,
    this.showRightAlignButton = true,
    this.showOrderedListButton = true,
    this.showBulletListButton = true,
    this.showUrlButton = true,
    this.showCodeBlockButton = true,
    this.showQuoteBlockButton = true,
    this.showClipboardCutButton = true,
    this.showClipboardCopyButton = true,
    this.showClipboardPasteButton = true,
    this.showUserMentionButton = true,
    this.showSpoilerButton = true,
    this.showHideButton = true,
    this.showDivider = true,
    this.afterButtonPressed,
    this.focusNode,
    super.key,
  }) : _controller = controller,
       _config = config,
       _emojiPicker = emojiPicker,
       _colorPicker = colorPicker,
       _backgroundColorPicker = backgroundColorPicker,
       _urlPicker = urlPicker,
       _imagePicker = imagePicker,
       _usernamePicker = usernamePicker,
       _host = host;

  final BBCodeEditorController _controller;

  final BBCodeEditorToolbarConfiguration _config;

  final BBCodeEmojiPicker _emojiPicker;

  final BBCodeColorPicker? _colorPicker;
  final BBCodeColorPicker? _backgroundColorPicker;
  final BBCodeUrlPicker? _urlPicker;
  final BBCodeImagePicker? _imagePicker;
  final BBCodeUsernamePicker? _usernamePicker;

  /// The focus node shared with editor.
  final FocusNode? focusNode;

  /// Host of site.
  ///
  /// Used in picking urls if url does not contain a host.
  final String? _host;

  //////////// All customizable optional flags ////////////

  /// Show undo button.
  final bool showUndo;

  /// Show redo button.
  final bool showRedo;

  /// Show font family button.
  final bool showFontFamily;

  /// Show font size button.
  final bool showFontSize;

  /// Show bold text button.
  final bool showBoldButton;

  /// Show italic text button.
  final bool showItalicButton;

  /// Show underline text button.
  final bool showUnderlineButton;

  /// Show strikethrough text button.
  final bool showStrikethroughButton;

  /// Show superscript text button. text button.
  final bool showSuperscriptButton;

  /// Show text foreground color button.
  final bool showColorButton;

  /// Show text background color button.
  final bool showBackgroundColorButton;

  /// Show clear text format button.
  final bool showClearFormatButton;

  /// Show online url image button.
  ///
  /// Embed image.
  final bool showImageButton;

  /// Show emoji button.
  ///
  /// Embed emoji image.
  final bool showEmojiButton;

  /// Show align left button.
  final bool showLeftAlignButton;

  /// Show align center button.
  final bool showCenterAlignButton;

  /// Show align right button.
  final bool showRightAlignButton;

  /// Show ordered list button.
  ///
  /// ``` console
  /// 1. foo
  /// 2. bar
  /// ```
  final bool showOrderedListButton;

  /// Show bullet list button.
  ///
  /// ``` console
  /// * foo
  /// * bar
  /// ```
  final bool showBulletListButton;

  /// Show insert url button.
  final bool showUrlButton;

  ///  Show code block.
  final bool showCodeBlockButton;

  ///  Show quote content block.
  final bool showQuoteBlockButton;

  /// Show cut button.
  final bool showClipboardCutButton;

  /// Show copy button.
  final bool showClipboardCopyButton;

  /// Show paste button.
  final bool showClipboardPasteButton;

  /// Show user mention button.
  ///
  /// ```console
  /// @username
  /// ```
  final bool showUserMentionButton;

  /// Show spoiler embed block button.
  ///
  /// ```console
  /// [spoiler=$TITLE]$DATA[/spoiler]
  /// ```
  final bool showSpoilerButton;

  /// Show hide embed block button.
  ///
  /// ```console
  /// [hide=$POINTS]$DATA[/hide]
  /// ```
  final bool showHideButton;

  /// Show or hide divider button.
  ///
  /// ```console
  /// [hr]
  /// ```
  final bool showDivider;

  /// Callback when button pressed.
  final VoidCallback? afterButtonPressed;

  @override
  State<BBCodeEditorToolbar> createState() => _BBCodeEditorToolbarState();
}

class _BBCodeEditorToolbarState extends State<BBCodeEditorToolbar> {
  late final BBCodeEditorController controller;

  late final QuillToolbarColorButtonOptions colorButtonOptions;
  late final QuillToolbarColorButtonOptions backgroundColorButtonOptions;
  late final QuillToolbarLinkStyleButtonOptions urlButtonOptions;
  late final QuillToolbarBaseButtonOptions<dynamic, dynamic> baseOptions;

  /// Refer: flutter_quill/lib/src/widgets/toolbar/color/color_button.dart
  void _changeColor(QuillController controller, bool isBackground, Color? color) {
    if (color == null) {
      controller.formatSelection(isBackground ? const BackgroundAttribute(null) : const ColorAttribute(null));
      return;
    }
    var hex = colorToHex(color);
    hex = '#$hex';
    controller.formatSelection(isBackground ? BackgroundAttribute(hex) : ColorAttribute(hex));
  }

  @override
  void initState() {
    super.initState();
    controller = widget._controller;

    if (widget._colorPicker != null) {
      colorButtonOptions = QuillToolbarColorButtonOptions(
        customOnPressedCallback: (controller, isBackground) async {
          final initialColor =
              (controller.getSelectionStyle().attributes['color']?.value as String?)?.replaceFirst('#FF', '').toColor();
          final pickResult = await widget._colorPicker!(context, initialColor == null ? null : Color(initialColor));
          if (pickResult == null) {
            return;
          }

          if (pickResult.clearColor) {
            _changeColor(controller, false, null);
          } else {
            _changeColor(controller, false, pickResult.color);
          }
        },
      );
    } else {
      colorButtonOptions = const QuillToolbarColorButtonOptions();
    }
    if (widget._backgroundColorPicker != null) {
      backgroundColorButtonOptions = QuillToolbarColorButtonOptions(
        customOnPressedCallback: (controller, isBackground) async {
          final initialColor =
              (controller.getSelectionStyle().attributes['background']?.value as String?)
                  ?.replaceFirst('#FF', '')
                  .toColor();
          final pickResult = await widget._backgroundColorPicker!(
            context,
            initialColor == null ? null : Color(initialColor),
          );
          if (pickResult == null) {
            return;
          }

          if (pickResult.clearColor) {
            _changeColor(controller, true, null);
          } else {
            _changeColor(controller, true, pickResult.color);
          }
        },
      );
    } else {
      backgroundColorButtonOptions = const QuillToolbarColorButtonOptions();
    }

    if (widget._urlPicker != null) {
      urlButtonOptions = QuillToolbarLinkStyleButtonOptions(
        customOnPressedCallback: (controller) async {
          final initialLink = QuillTextLink.prepare(controller);
          final urlResult = await widget._urlPicker!(context, initialLink.link, initialLink.text);
          if (urlResult == null) {
            return;
          }
          final description = urlResult.description ?? urlResult.url;
          // Prepend host only if:
          //
          // * Host not null.
          // * Url does not have host.
          final url =
              widget._host != null && !urlResult.url.startsWith('http://') && !urlResult.url.startsWith('https://')
                  ? '${widget._host}/${urlResult.url}'
                  : urlResult.url;

          QuillTextLink(description, url).submit(controller);
        },
      );
    } else {
      urlButtonOptions = const QuillToolbarLinkStyleButtonOptions();
    }

    // Initialize toolbar button base options.
    baseOptions = QuillToolbarBaseButtonOptions(
      afterButtonPressed: () {
        widget.afterButtonPressed?.call();
        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          // Try focus on editor again.
          widget.focusNode?.requestFocus();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BBCodeLocalizationsWidget(
      child: Builder(
        builder:
            (context) => Wrap(
              children: [
                // Undo.
                if (widget.showUndo)
                  QuillToolbarHistoryButton(isUndo: true, controller: controller, baseOptions: baseOptions),

                // Redo.
                if (widget.showRedo)
                  QuillToolbarHistoryButton(isUndo: false, controller: controller, baseOptions: baseOptions),

                // Font size.
                if (widget.showFontSize)
                  QuillToolbarFontSizeButton(
                    controller: controller,
                    options: const QuillToolbarFontSizeButtonOptions(items: defaultFontSizeMap),
                    baseOptions: baseOptions,
                  ),

                // Bold.
                if (widget.showBoldButton)
                  QuillToolbarToggleStyleButton(
                    controller: controller,
                    attribute: Attribute.bold,
                    baseOptions: baseOptions,
                  ),

                // Italic.
                if (widget.showItalicButton)
                  QuillToolbarToggleStyleButton(
                    controller: controller,
                    attribute: Attribute.italic,
                    baseOptions: baseOptions,
                  ),

                // Underline.
                if (widget.showUnderlineButton)
                  QuillToolbarToggleStyleButton(
                    controller: controller,
                    attribute: Attribute.underline,
                    baseOptions: baseOptions,
                  ),

                // Strike through.
                if (widget.showStrikethroughButton)
                  QuillToolbarToggleStyleButton(
                    controller: controller,
                    attribute: Attribute.strikeThrough,
                    baseOptions: baseOptions,
                  ),

                // Superscript.
                if (widget.showSuperscriptButton)
                  QuillToolbarToggleStyleButton(
                    controller: controller,
                    attribute: Attribute.superscript,
                    baseOptions: baseOptions,
                  ),

                // Foreground color, aka text color.
                if (widget.showColorButton)
                  QuillToolbarColorButton(
                    controller: controller,
                    isBackground: false,
                    baseOptions: baseOptions,
                    options: colorButtonOptions,
                  ),

                // Background color.
                if (widget.showBackgroundColorButton)
                  QuillToolbarColorButton(
                    controller: controller,
                    isBackground: true,
                    baseOptions: baseOptions,
                    options: backgroundColorButtonOptions,
                  ),

                // Clear format.
                if (widget.showClearFormatButton)
                  QuillToolbarClearFormatButton(controller: controller, baseOptions: baseOptions),

                // Image picker.
                if (widget.showImageButton)
                  // FIXME: Do not add l10n here.
                  BBCodeEditorToolbarImageButton(controller: controller, imagePicker: widget._imagePicker),

                // Emoji picker.
                if (widget.showEmojiButton)
                  BBCodeEditorToolbarEmojiButton(controller: controller, emojiPicker: widget._emojiPicker),

                // User mention.
                if (widget.showUserMentionButton)
                  BBCodeEditorToolbarUserMentionButton(controller: controller, usernamePicker: widget._usernamePicker),

                // Spoiler.
                if (widget.showSpoilerButton)
                  BBCodeEditorToolbarSpoilerV2Button(
                    controller: controller,
                    baseOptions: baseOptions,
                    options: BBCodeSpoilerV2ButtonOptions(tooltip: context.bbcodeL10n.spoiler),
                  ),

                // Hide.
                if (widget.showHideButton) BBCodeEditorToolbarHideButton(controller: controller),

                // Divider.
                if (widget.showDivider) BBCodeEditorToolbarDividerButton(controller: controller),

                // Align left.
                if (widget.showLeftAlignButton)
                  QuillToolbarToggleStyleButton(
                    controller: controller,
                    attribute: Attribute.leftAlignment,
                    baseOptions: baseOptions,
                  ),

                // Align center.
                if (widget.showLeftAlignButton)
                  QuillToolbarToggleStyleButton(
                    controller: controller,
                    attribute: Attribute.centerAlignment,
                    baseOptions: baseOptions,
                  ),

                // Align right.
                if (widget.showLeftAlignButton)
                  QuillToolbarToggleStyleButton(
                    controller: controller,
                    attribute: Attribute.rightAlignment,
                    baseOptions: baseOptions,
                  ),

                // Ordered list.
                if (widget.showOrderedListButton)
                  QuillToolbarToggleStyleButton(
                    controller: controller,
                    attribute: Attribute.ol,
                    baseOptions: baseOptions,
                  ),

                // Bullet list.
                if (widget.showBulletListButton)
                  QuillToolbarToggleStyleButton(
                    controller: controller,
                    attribute: Attribute.ul,
                    baseOptions: baseOptions,
                  ),

                // Code block.
                if (widget.showCodeBlockButton)
                  QuillToolbarToggleStyleButton(
                    controller: controller,
                    attribute: Attribute.codeBlock,
                    baseOptions: baseOptions,
                  ),

                // Quote block.
                if (widget.showQuoteBlockButton)
                  QuillToolbarToggleStyleButton(
                    controller: controller,
                    attribute: Attribute.blockQuote,
                    baseOptions: baseOptions,
                  ),

                // Url picker.
                if (widget.showUrlButton)
                  QuillToolbarLinkStyleButton(
                    controller: controller,
                    baseOptions: baseOptions,
                    options: urlButtonOptions,
                  ),

                // Export and import.
                QuillToolbarCustomButton(
                  controller: controller,
                  options: BBCodePortationButtonOptions(
                    tooltip: context.bbcodeL10n.portationTitle,
                    onPressed: () async => openPortationModalBottomSheet(context, widget._controller),
                  ),
                  baseOptions: baseOptions,
                ),
              ],
            ),
      ),
    );
  }
}

/// Copied from flutter-quill
// Without the hash sign (`#`).
String colorToHex(Color color) {
  int floatToInt8(double x) => (x * 255.0).round() & 0xff;

  final alpha = floatToInt8(color.a);
  final red = floatToInt8(color.r);
  final green = floatToInt8(color.g);
  final blue = floatToInt8(color.b);

  return '${alpha.toRadixString(16).padLeft(2, '0')}'
          '${red.toRadixString(16).padLeft(2, '0')}'
          '${green.toRadixString(16).padLeft(2, '0')}'
          '${blue.toRadixString(16).padLeft(2, '0')}'
      .toUpperCase();
}
