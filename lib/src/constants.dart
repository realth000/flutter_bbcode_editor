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
const defaultLevelToFontSizeMap = <int, double>{
  // Header1,
  7: 49.0,
  // Header2,
  6: 33.0,
  // Header3,
  5: 25.0,
  // Header4,
  4: 19.0,
  // Header5,
  3: 18.0,
  // Header6,
  2: 14.0,
  // Header7,
  1: 11.0,
};

/// Default header font weight.
const defaultHeaderFontWeight = FontWeight.w600;
