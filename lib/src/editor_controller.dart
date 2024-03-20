part of 'editor.dart';

/// Controller of editor.
///
/// # Goal
///
/// [BBCodeEditorController] aims to let the application developer access features of
/// the editor outside the editor.
///
/// For example, developer can use a customized button to trigger "export data
/// from editor" outside the editor context menu and editor toolbar.
///
/// Of course it's ok to use the default context menu or the toolbar to do such
/// action, controller here just gives more flexibility.
final class BBCodeEditorController extends ValueNotifier<BBCodeEditorValue> {
  /// Controller.
  BBCodeEditorController() : super(BBCodeEditorValue.empty);

  BBCodeEditorState? _state;

  void _update() {
    final collapsed = _state?.editorState?.selection?.isCollapsed ?? true;
    final bold = _state?.isBold() ?? false;
    final italic = _state?.isItalic() ?? false;
    final underline = _state?.isUnderline() ?? false;
    final strikethrough = _state?.isStrikethrough() ?? false;
    final foregroundColor = _state?.getForegroundColor()?.tryToColor();
    final backgroundColor = _state?.getBackgroundColor()?.tryToColor();
    final _f = _state?.getFontSize();
    final fontSizeLevel = defaultLevelToFontSizeMap.entries
        .firstWhereOrNull((e) => e.value == _f)
        ?.key;
    value = value.copyWith(
      collapsed: collapsed,
      bold: bold,
      italic: italic,
      underline: underline,
      strikethrough: strikethrough,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      fontSizeLevel: fontSizeLevel,
      clearForegroundColor: foregroundColor == null,
      clearBackgroundColor: backgroundColor == null,
      clearFontSizeLevel: fontSizeLevel == null,
    );
  }

  bool get collapsed => value.collapsed;

  set _collapsed(bool collapsed) =>
      value = value.copyWith(collapsed: collapsed);

  bool get bold => value.bold;

  set _bold(bool bold) => value = value.copyWith(bold: bold);

  bool get italic => value.italic;

  set _italic(bool italic) => value = value.copyWith(italic: italic);

  bool get underline => value.underline;

  set _underline(bool underline) =>
      value = value.copyWith(underline: underline);

  bool get strikethrough => value.strikethrough;

  set _strikethrough(bool strikeThrough) =>
      value = value.copyWith(strikethrough: strikeThrough);

  Color? get foregroundColor => value.foregroundColor;

  set _foregroundColor(Color? foregroundColor) => value = value.copyWith(
        foregroundColor: foregroundColor,
        clearForegroundColor: foregroundColor == null,
      );

  Color? get backgroundColor => value.backgroundColor;

  set _backgroundColor(Color? backgroundColor) => value = value.copyWith(
        backgroundColor: backgroundColor,
        clearBackgroundColor: backgroundColor == null,
      );

  /// Get the level of font size.
  ///
  /// Return null if is invalid font size.
  double? get fontSize {
    final sizeValue = value.fontSizeLevel ?? -1;
    for (final entry in defaultLevelToFontSizeMap.entries) {
      if (entry.key == sizeValue) {
        return entry.value;
      }
    }
    return null;
  }

  set _fontSizeLevel(int? fontSizeLevel) => value = value.copyWith(
        fontSizeLevel: fontSizeLevel,
        clearFontSizeLevel: fontSizeLevel == null,
      );

  // ignore: avoid_setters_without_getters
  set _bind(BBCodeEditorState state) {
    _state = state;
  }

  /// Import text data as [fileType] from some file.
  ///
  /// This function will ask user to choose a file and import the text data
  /// into editor. Data is treated in format [fileType].
  Future<void> importData(BBCodeFileType fileType) async {
    await _state?.importData(fileType);
  }

  /// Export text data in [fileType] to a file.
  ///
  /// This function will ask user to choose a file and export the text data
  /// in that file in format [fileType].
  ///
  /// After export data successfully, call [exportCallback]. You can do some
  /// notice such as toasting or show a snack bar.
  Future<void> exportData(
    BBCodeFileType fileType,
    FutureOr<void> Function(BuildContext context, String exportPath)?
        exportCallback,
  ) async {
    await _state?.exportData(fileType, exportCallback);
  }

  /// Convert the text data into bbcode.
  Future<String?> convertToBBCode() async {
    return await _state?.convertToBBCode();
  }

  /////////////////////// Triggers ///////////////////////

  /// From appflowy project:
  /// lib/plugins/document/presentation/editor_plugins/mobile_toolbar_item/mobile_text_decoration_item.dart
  Future<void> triggerBold() async {
    _bold = !bold;
    await _state?.triggerBold();
  }

  Future<void> triggerItalic() async {
    _italic = !italic;
    await _state?.triggerItalic();
  }

  Future<void> triggerUnderline() async {
    _underline = !underline;
    await _state?.triggerUnderline();
  }

  Future<void> triggerStrikethrough() async {
    _strikethrough = !strikethrough;
    await _state?.triggerStrikethrough();
  }

  Future<void> setForegroundColor(Color color) async {
    _foregroundColor = color;
    await _state?.triggerForegroundColor(color.toHex());
  }

  Future<void> setBackgroundColor(Color color) async {
    _backgroundColor = color;
    await _state?.triggerBackgroundColor(color.toHex());
  }

  /// Set the font size level.
  ///
  /// Level is available in [defaultLevelToFontSizeMap] list.
  ///
  /// Do nothing if [level] is invalid.
  Future<void> setFontSizeLevel(int level) async {
    final sizeValue = defaultLevelToFontSizeMap[level];

    if (sizeValue == null) {
      // Invalid level.
      return;
    }
    _fontSizeLevel = level;
    await _state?.triggerFontSize(sizeValue);
  }

  // TODO: Support same-line-image.
  /// Insert an emoji in the current selection position.
  ///
  /// Emoji is represent as [code] in bbcode and display like [emoji].
  Future<void> insertEmoji(String code) async {
    await _state?.insertEmoji(code);
  }

  /// Insert raw emoji string into the editor
  ///
  /// Only a fallback choice when same-line-image is not supported.
  Future<void> insertRawEmoji(String code) async {
    await _state?.insertRawCode(code);
  }

  /// Insert raw url string into the editor
  ///
  /// Only a fallback choice when same-line-url-block is not supported.
  Future<void> insertRawUrl(String description, String url) async {
    await _state?.insertRawUrl(description, url);
  }

  /// Insert url block into the editor.
  ///
  /// Url is [url], show [description].
  Future<void> insertUrl(String description, String url) async {
    await _state?.insertUrl(description, url);
  }
}
