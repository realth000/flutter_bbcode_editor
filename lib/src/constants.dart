import 'dart:ui';

// Colors does not need document.
// ignore_for_file: public_member_api_docs

// TODO: Dynamic font size.
/// Default available font size.
///
/// default font size (when not set) should be 19.
///
///
/// Originally on the web site is:
///
///
/// // x-small
/// '1': '16.0',
/// // small
/// '2': '17.0',
/// // medium
/// '3': '21.0',
/// // large
/// '4': '24.0',
/// // x-large
/// '5': '31.0',
/// // xx-large
/// '6': '42.0',
/// // xxx-large
/// '7': '64.0',
///
/// To keep the same appearance with html muncher， set to:
///
/// FontSize.size1 => 11.0,
/// FontSize.size2 => 14.0,
/// FontSize.size3 => 17.0,
/// FontSize.size4 => 19.0,
/// FontSize.size5 => 25.0,
/// FontSize.size6 => 33.0,
/// FontSize.size7 => 49.0,
/// FontSize.notSupport => 18.0, // Default is 18
const defaultFontSizeMap = <String, String>{
  // x-small
  '1': '11.0',
  // small
  '2': '14.0',
  // medium
  '3': '17.0',
  // large
  '4': '19.0',
  // x-large
  '5': '25.0',
  // xx-large
  '6': '33.0',
  // xxx-large
  '7': '49.0',
  // Not set
  '0': '0',
};

/// Color names.
///
/// Used by TSDM.
enum BBCodeEditorColor {
  black('黑色', 'Black', Color(0xFF000000)),
  sienna('赭色', 'Sienna', Color(0xFFA0522D)),
  darkOliveGreen('暗橄榄绿色', 'DarkOliveGreen', Color(0xFF556B2F)),
  darkGreen('暗绿色', 'DarkGreen', Color(0xFF006400)),
  darkSlateBlue('暗灰蓝色', 'DarkSlateBlue', Color(0xFF483D8B)),
  navy('海军色', 'Navy', Color(0xFF000080)),
  indigo('靛青色', 'Indigo', Color(0xFF4B0082)),
  darkSlateGray('墨绿色', 'DarkSlateGray', Color(0xFF2F4F4F)),
  darkRed('暗红色', 'DarkRed', Color(0xFF8B0000)),
  darkOrange('暗桔黄色', 'DarkOrange', Color(0xFFFF8C00)),
  olive('橄榄色', 'Olive', Color(0xFF808000)),
  green('绿色', 'Green', Color(0xFF008000)),
  teal('水鸭色', 'Teal', Color(0xFF008080)),
  blue('蓝色', 'Blue', Color(0xFF0000FF)),
  slateGray('灰石色', 'SlateGray', Color(0xFF708090)),
  dimGray('暗灰色', 'DimGray', Color(0xFF696969)),
  red('红色', 'Red', Color(0xFFFF0000)),
  sandyBrown('沙褐色', 'SandyBrown', Color(0xFFF4A460)),
  yellowGreen('黄绿色', 'YellowGreen', Color(0xFF9ACD32)),
  seaGreen('海绿色', 'SeaGreen', Color(0xFF2E8B57)),
  mediumTurquoise('间绿宝石', 'MediumTurquoise', Color(0xFF48D1CC)),
  royalBlue('皇家蓝', 'RoyalBlue', Color(0xFF4169E1)),
  purple('紫色', 'Purple', Color(0xFF800080)),
  gray('灰色', 'Gray', Color(0xFF808080)),
  magenta('红紫色', 'Magenta', Color(0xFFFF00FF)),
  orange('橙色', 'Orange', Color(0xFFFFA500)),
  yellow('黄色', 'Yellow', Color(0xFFFFFF00)),
  lime('酸橙色', 'Lime', Color(0xFF00FF00)),
  cyan('青色', 'Cyan', Color(0xFF00FFFF)),
  deepSkyBlue('深天蓝色', 'DeepSkyBlue', Color(0xFF00BFFF)),
  darkOrchid('暗紫色', 'DarkOrchid', Color(0xFF9932CC)),
  silver('银色', 'Silver', Color(0xFFC0C0C0)),
  pink('粉色', 'Pink', Color(0xFFFFC0CB)),
  wheat('浅黄色', 'Wheat', Color(0xFFF5DEB3)),
  lemonChiffon('柠檬绸色', 'LemonChiffon', Color(0xFFFFFACD)),
  paleGreen('苍绿色', 'PaleGreen', Color(0xFF98FB98)),
  paleTurquoise('苍宝石绿', 'PaleTurquoise', Color(0xFFAFEEEE)),
  lightBlue('亮蓝色', 'LightBlue', Color(0xFFADD8E6)),
  plum('洋李色', 'Plum', Color(0xFFDDA0DD)),
  white('白色', 'White', Color(0xFFFFFFFF));

  /// Constructor.
  const BBCodeEditorColor(this.name, this.namedColor, this.color);

  final String name;
  final String namedColor;
  final Color color;

  @override
  String toString() => namedColor;
}
