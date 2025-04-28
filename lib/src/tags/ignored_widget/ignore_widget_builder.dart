import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/tags/ignored_widget/ignored_widget_embed.dart';
import 'package:flutter_bbcode_editor/src/tags/image/image_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Embed builder for ignored widget type.
final class BBCodeIgnoredWidgetBuilder extends EmbedBuilder {
  /// Constructor.
  const BBCodeIgnoredWidgetBuilder(this.ignoredContentBuilder);

  /// Function to build widget from arbitrary data string.
  ///
  /// The builder can hold logic on how to dispatch the build task.
  final Widget Function(String) ignoredContentBuilder;

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final info = BBCodeIgnoredWidgetInfo.fromJson(embedContext.node.value.data as String);
    return ignoredContentBuilder(info.data);
  }

  @override
  String get key => BBCodeImageKeys.type;
}
