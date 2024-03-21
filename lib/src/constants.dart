import 'dart:ui';

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
