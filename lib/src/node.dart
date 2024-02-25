import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter_bbcode_editor/src/delta.dart';

/// Provides methods related to bbcode format.
///
/// About bbcode: https://en.wikipedia.org/wiki/BBCode
extension BBCodeNode on Node {
  /// Convert the text info into a single bbcode node.
  String toBBCode() {
    final data = switch (type) {
      'page' => '',
      'heading' => _buildHeading(),
      String() => '',
    };
    if (data.isNotEmpty) {
      print('>>> Node toBBCode data: $data');
    }
    return data;
  }

  /// Heading
  ///
  /// header will be converted to `size` tag.
  ///
  /// # Json Document
  ///
  /// ## Attr
  ///
  /// * `level`: required, header level, also the size value in bbcode format.
  ///
  /// # BBCode
  ///
  /// ```
  /// [size=$level]xxx[/size].
  /// ```
  ///
  /// ## Attr
  ///
  /// Required, available value: 1, 2, 3, 4, 5, 6, 7.
  String _buildHeading() {
    final level = switch (attributes['level']) {
      '1' => '7',
      '2' => '6',
      '3' => '5',
      '4' => '4',
      '5' => '3',
      '6' => '2',
      '7' => '1',
      _ => '1', // Return the largest size to let user notice it.
    };
    final content =
        delta?.whereType<TextInsert>().map((e) => e.toBBCode()).join();
    print('>>> heading attr=${attributes}');
    return '[size=$level]$content[/size]';
  }
}
