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

const docTagPage = 'page';
const docTagHeading = 'heading';
const docTagParagraph = 'paragraph';
const docTagOrderedList = 'numbered_list';
const docTagUnorderedList = 'bulleted_list';
const docTagImage = 'image';

/// Default font size for body text.
const defaultFontSize = 14.0;

/// Default header text font size with given level.
const defaultLevelToFontSize = [
  // Header1,
  49.0,
  // Header2,
  33.0,
  // Header3,
  25.0,
  // Header4,
  19.0,
  // Header5,
  18.0,
  // Header6,
  14.0,
  // Header7,
  11.0,
];

/// Default header font weight.
const defaultHeaderFontWeight = FontWeight.w600;
