import 'dart:ui';
// ignore_for_file: public_member_api_docs

const defaultDocument = '''
{
  "document" : {
    "type": "page",
    "children": [
      {
        "type": "paragraph",
        "data": {
          "delta": []
        }
      }
    ]
  }
}
''';

const decorationNameBold = 'bold';
const decorationNameItalic = 'italic';
const decorationNameUnderline = 'underline';
const decorationNameStrikethrough = 'strikethrough';
const decorationForegroundColor = 'font_color';
const decorationBackgroundColor = 'bg_color';
const decorationFontSize = 'font_size';

const decorationList = [
  decorationNameBold,
  decorationNameItalic,
  decorationNameUnderline,
  decorationNameStrikethrough,
  decorationForegroundColor,
  decorationBackgroundColor,
  decorationFontSize,
];

const docTagPage = 'page';
const docTagHeading = 'heading';
const docTagParagraph = 'paragraph';
const docTagOrderedList = 'numbered_list';
const docTagUnorderedList = 'bulleted_list';
const docTagImage = 'image';

/// Default font size for body text.
const defaultFontSize = 14.0;

/// Default header text font size with given level.
///
/// Normal size level is 19
const defaultLevelToFontSizeMap = <int, double>{
  // Header1,
  7: 49.0, // 64
  // Header2,
  6: 33.0, // 43
  // Header3,
  5: 25.0, // 33
  // Header4,
  4: 19.0, // 25
  // Header5,
  3: 18.0, // 22
  // Header6,
  2: 12.0, // 18
  // Header7,
  1: 11.0, // 14
};

/// Default header font weight.
const defaultHeaderFontWeight = FontWeight.w600;

enum BBCodeEditorColor {
  black('黑色', Color(0xFF000000)),
  sienna('赭色', Color(0xFF804224)),
  darkOliveGreen('暗橄榄绿色', Color(0xFF445626)),
  darkGreen('暗绿色', Color(0xFF005000)),
  darkSlateBlue('暗灰蓝色', Color(0xFF3a316f)),
  navy('海军色', Color(0xFF000066)),
  indigo('靛青色', Color(0xFF3c0068)),
  darkSlateGray('墨绿色', Color(0xFF263f3f)),
  darkRed('暗红色', Color(0xFF6f0000)),
  darkOrange('暗桔黄色', Color(0xFFcc7000)),
  olive('橄榄色', Color(0xFF666600)),
  green('绿色', Color(0xFF006600)),
  teal('水鸭色', Color(0xFF006666)),
  blue('蓝色', Color(0xFF0000cc)),
  slateGray('灰石色', Color(0xFF596673)),
  dimGray('暗灰色', Color(0xFF4f5659)),
  red('红色', Color(0xFFcc0000)),
  sandyBrown('沙褐色', Color(0xFF8f470a)),
  yellowGreen('黄绿色', Color(0xFF647b1e)),
  seaGreen('海绿色', Color(0xFF256f46)),
  mediumTurquoise('间绿宝石', Color(0xFF269793)),
  royalBlue('皇家蓝', Color(0xFF193a9e)),
  purple('紫色', Color(0xFF660066)),
  gray('灰色', Color(0xFF60686c)),
  magenta('红紫色', Color(0xFFcc00cc)),
  orange('橙色', Color(0xFFcc8400)),
  yellow('黄色', Color(0xFF999900)),
  lime('酸橙色', Color(0xFF33cc00)),
  cyan('青色', Color(0xFF00cccc)),
  deepSkyBlue('深天蓝色', Color(0xFF0099cc)),
  darkOrchid('暗紫色', Color(0xFF7a28a3)),
  silver('银色', Color(0xFF3c4143)),
  pink('粉色', Color(0xFF590010)),
  wheat('浅黄色', Color(0xFF5b3f0c)),
  lemonChiffon('柠檬绸色', Color(0xFF3d3700)),
  paleGreen('苍绿色', Color(0xFF1f6f04)),
  paleTurquoise('苍宝石绿', Color(0xFF135a5a)),
  lightBlue('亮蓝色', Color(0xFF1b4958)),
  plum('洋李色', Color(0xFF5f225f)),
  white('白色', Color(0xFF181a1b));

  /// Constructor.
  const BBCodeEditorColor(this.name, this.color);

  final String name;
  final Color color;

  @override
  String toString() => name;
}
