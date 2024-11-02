import 'dart:ui';

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
  sienna('赭色', 'Sienna', Color(0xFF804224)),
  darkOliveGreen('暗橄榄绿色', 'DarkOliveGreen', Color(0xFF445626)),
  darkGreen('暗绿色', 'DarkGreen', Color(0xFF005000)),
  darkSlateBlue('暗灰蓝色', 'DarkSlateBlue', Color(0xFF3a316f)),
  navy('海军色', 'Navy', Color(0xFF000066)),
  indigo('靛青色', 'Indigo', Color(0xFF3c0068)),
  darkSlateGray('墨绿色', 'DarkSlateGray', Color(0xFF263f3f)),
  darkRed('暗红色', 'DarkRed', Color(0xFF6f0000)),
  darkOrange('暗桔黄色', 'DarkOrange', Color(0xFFcc7000)),
  olive('橄榄色', 'Olive', Color(0xFF666600)),
  green('绿色', 'Green', Color(0xFF006600)),
  teal('水鸭色', 'Teal', Color(0xFF006666)),
  blue('蓝色', 'Blue', Color(0xFF0000cc)),
  slateGray('灰石色', 'SlateGray', Color(0xFF596673)),
  dimGray('暗灰色', 'DimGray', Color(0xFF4f5659)),
  red('红色', 'Red', Color(0xFFcc0000)),
  sandyBrown('沙褐色', 'SandyBrown', Color(0xFF8f470a)),
  yellowGreen('黄绿色', 'YellowGreen', Color(0xFF647b1e)),
  seaGreen('海绿色', 'SeaGreen', Color(0xFF256f46)),
  mediumTurquoise('间绿宝石', 'MediumTurquoise', Color(0xFF269793)),
  royalBlue('皇家蓝', 'RoyalBlue', Color(0xFF193a9e)),
  purple('紫色', 'Purple', Color(0xFF660066)),
  gray('灰色', 'Gray', Color(0xFF60686c)),
  magenta('红紫色', 'Magenta', Color(0xFFcc00cc)),
  orange('橙色', 'Orange', Color(0xFFcc8400)),
  yellow('黄色', 'Yellow', Color(0xFF999900)),
  lime('酸橙色', 'Lime', Color(0xFF33cc00)),
  cyan('青色', 'Cyan', Color(0xFF00cccc)),
  deepSkyBlue('深天蓝色', 'DeepSkyBlue', Color(0xFF0099cc)),
  darkOrchid('暗紫色', 'DarkOrchid', Color(0xFF7a28a3)),
  silver('银色', 'Silver', Color(0xFF3c4143)),
  pink('粉色', 'Pink', Color(0xFF590010)),
  wheat('浅黄色', 'Wheat', Color(0xFF5b3f0c)),
  lemonChiffon('柠檬绸色', 'LemonChiffon', Color(0xFF3d3700)),
  paleGreen('苍绿色', 'PaleGreen', Color(0xFF1f6f04)),
  paleTurquoise('苍宝石绿', 'PaleTurquoise', Color(0xFF135a5a)),
  lightBlue('亮蓝色', 'LightBlue', Color(0xFF1b4958)),
  plum('洋李色', 'Plum', Color(0xFF5f225f)),
  white('白色', 'White', Color(0xFF181a1b));

  /// Constructor.
  const BBCodeEditorColor(this.name, this.namedColor, this.color);

  final String name;
  final String namedColor;
  final Color color;

  @override
  String toString() => namedColor;
}
