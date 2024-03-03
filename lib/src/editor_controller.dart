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
final class BBCodeEditorController {
  BBCodeEditorState? _state;

  bool get isBold => _state?.isBold() ?? false;

  bool get isItalic => _state?.isItalic() ?? false;

  bool get isUnderline => _state?.isUnderline() ?? false;

  bool get isStrikethrough => _state?.isStrikethrough() ?? false;

  Color? get getForegroundColor => _state?.getForegroundColor()?.tryToColor();

  Color? get getBackgroundColor => _state?.getBackgroundColor()?.tryToColor();

  /// Get the level of font size.
  ///
  /// Return null if is invalid font size.
  int? get getFontSize {
    final sizeValue = _state?.getFontSize() ?? -1;
    for (final entry in defaultLevelToFontSizeMap.entries) {
      if (entry.value == sizeValue) {
        return entry.key;
      }
    }
    return null;
  }

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
    await _state?.triggerBold();
  }

  Future<void> triggerItalic() async {
    await _state?.triggerItalic();
  }

  Future<void> triggerUnderline() async {
    await _state?.triggerUnderline();
  }

  Future<void> triggerStrikethrough() async {
    await _state?.triggerStrikethrough();
  }

  Future<void> setForegroundColor(Color color) async {
    await _state?.triggerForegroundColor(color.toHex());
  }

  Future<void> setBackgroundColor(Color color) async {
    await _state?.triggerBackgroundColor(color.toHex());
  }

  /// Set the font size level.
  ///
  /// Level is available in [defaultLevelToFontSizeMap] list.
  ///
  /// Do nothing if [level] is invalid.
  Future<void> setFontSize(int level) async {
    final sizeValue = defaultLevelToFontSizeMap[level];

    if (sizeValue == null) {
      // Invalid level.
      return;
    }
    await _state?.triggerFontSize(sizeValue);
  }
}
