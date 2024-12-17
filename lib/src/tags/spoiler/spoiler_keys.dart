/// Keys related to spoiler tag.
final class BBCodeSpoilerKeys {
  BBCodeSpoilerKeys._();

  /// Tag type.
  static const String type = 'bbcodeSpoiler';

  /// Plain text display as title.
  static const String title = 'title';

  /// Raw bbcode body inside the spoiler block.
  static const String body = 'data';

  /// Spoiler should be rendered in collapsed state or not.
  static const String collapsed = 'collapsed';
}
