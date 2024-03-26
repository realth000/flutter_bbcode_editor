part of 'editor.dart';

class BBCodeEditorValue {
  const BBCodeEditorValue({
    this.editorVisible = true,
    this.collapsed = false,
    this.bold = false,
    this.italic = false,
    this.underline = false,
    this.strikethrough = false,
    this.foregroundColor,
    this.backgroundColor,
    this.fontSizeLevel,
  });

  static const empty = BBCodeEditorValue();

  final bool editorVisible;
  final bool collapsed;
  final bool bold;
  final bool italic;
  final bool underline;
  final bool strikethrough;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final int? fontSizeLevel;

  /// Copy with
  BBCodeEditorValue copyWith({
    bool? editorVisible,
    bool? collapsed,
    bool? bold,
    bool? italic,
    bool? underline,
    bool? strikethrough,
    Color? foregroundColor,
    Color? backgroundColor,
    int? fontSizeLevel,
    bool clearForegroundColor = false,
    bool clearBackgroundColor = false,
    bool clearFontSizeLevel = false,
  }) {
    return BBCodeEditorValue(
      editorVisible: editorVisible ?? this.editorVisible,
      collapsed: collapsed ?? this.collapsed,
      bold: bold ?? this.bold,
      italic: italic ?? this.italic,
      underline: underline ?? this.underline,
      strikethrough: strikethrough ?? this.strikethrough,
      foregroundColor: clearForegroundColor
          ? null
          : (foregroundColor ?? this.foregroundColor),
      backgroundColor: clearBackgroundColor
          ? null
          : (backgroundColor ?? this.backgroundColor),
      fontSizeLevel:
          clearFontSizeLevel ? null : (fontSizeLevel ?? this.fontSizeLevel),
    );
  }

  @override
  String toString() => 'BBCodeEditorValue { '
      'editorVisible=$editorVisible'
      'collapsed=$collapsed '
      'bold=$bold, italic=$italic, '
      'underline=$underline, strikethrough=$strikethrough '
      'foregroundColor=$foregroundColor, backgroundColor=$backgroundColor '
      'fontSizeLevel=$fontSizeLevel '
      '}';
}
