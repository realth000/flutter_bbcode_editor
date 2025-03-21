import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bbcode_editor/src/tags/image/image_embed.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Functions convert [Embed] to bbcode content.
///
/// An [Embed] is something embedded in content, like an image.
typedef EmbedToBBCode = void Function(Embed embed, StringSink out);

// TODO: Async?
/// External function, provide emoji image from bbcode [code].
typedef BBCodeEmojiProvider = Widget Function(BuildContext context, String code);

/// External emoji picker function.
///
/// Calling from emoji site.
typedef BBCodeEmojiPicker = FutureOr<String?> Function(BuildContext context);

/// External function to call when user tap on text with user mention attribute.
typedef BBCodeUserMentionHandler = FutureOr<void> Function(String username);

/// External function build a image widget from given image [url].
typedef BBCodeImageProvider = Widget Function(BuildContext context, String url, int? width, int? height);

/// Function to pick an image.
///
///
/// The following optional parameters are passed (may be not null) when editing
/// already inserted images:
///
/// * [link] image url.
/// * [width] image width.
/// * [height] image height.
typedef BBCodeImagePicker =
    Future<BBCodeImageInfo?> Function(BuildContext context, String? link, int? width, int? height);

/// Function to launch an url.
typedef BBCodeUrlLauncher = void Function(String)?;
