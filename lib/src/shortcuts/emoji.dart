import 'dart:typed_data';

/// Provider that provide the emoji image from the given url.
///
/// Generally it's a http client but you can do validation and caching in
/// this function.
typedef EmojiProvider = Future<Uint8List> Function(String url);

/// Definition of an emoji in toolbar.
class Emoji {
  /// Constructor.
  const Emoji({
    required this.name,
    required this.code,
    required this.url,
  });

  /// Display name.
  final String name;

  /// Emoji bbcode.
  final String code;

  /// Url to fetch the emoji.
  final String url;
}

/// A group of emoji.
class EmojiGroup {
  /// Constructor.
  const EmojiGroup({
    required this.name,
    required this.emojiList,
  });

  /// Group name.
  final String name;

  /// All emoji in the group
  final List<Emoji> emojiList;
}
