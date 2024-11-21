/// Keys related to hide tag.
final class BBCodeHideKeys {
  BBCodeHideKeys._();

  /// Tag type.
  static const String type = 'bbcodeHide';

  /// Minimum points to see the hide content.
  ///
  /// A empty points stands for reply requirements: user need to reply to see
  /// the content.
  static const String points = 'points';

  /// Raw bbcode body inside the hide block.
  static const String body = 'data';
}
