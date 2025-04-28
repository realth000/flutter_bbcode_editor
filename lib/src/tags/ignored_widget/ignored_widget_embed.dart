import 'dart:convert';

import 'package:flutter_bbcode_editor/src/tags/ignored_widget/ignored_widget_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

// FIXME: Waiting for upstream fix. Should derive from CustomEmbedBlock.
/// Ignored contents.
final class BBCodeIgnoredWidgetEmbed extends Embeddable {
  /// Constructor.
  BBCodeIgnoredWidgetEmbed(BBCodeIgnoredWidgetInfo data) : super(BBCodeIgnoredWidgetKeys.type, data);

  /// Construct from quill document.
  factory BBCodeIgnoredWidgetEmbed.raw({required String data}) =>
      BBCodeIgnoredWidgetEmbed(BBCodeIgnoredWidgetInfo(data: data));
}

/// Delta here.
final class BBCodeIgnoredWidgetInfo {
  /// Constructor.
  const BBCodeIgnoredWidgetInfo({required this.data});

  /// Build from json.
  ///
  /// ```json
  /// {
  ///   "data": $DATA
  /// }
  /// ```
  factory BBCodeIgnoredWidgetInfo.fromJson(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    return BBCodeIgnoredWidgetInfo(data: data[BBCodeIgnoredWidgetKeys.data] as String);
  }

  /// Convert to bbcode.
  ///
  /// Ignored.
  static void toBBCode(Embed embed, StringSink out) {
    // Do nothing.
  }

  /// The raw data content.
  final String data;

  /// Convert info json.
  String toJson() => jsonEncode(<String, dynamic>{BBCodeIgnoredWidgetKeys.data: data});

  @override
  String toString() => 'BBCodeIgnoredWidget{ data=$data }';
}
