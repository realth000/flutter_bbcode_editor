/// All keys used in delta json for emoji support.
final class BBCodeEmojiKeys {
  BBCodeEmojiKeys._();

  /// Emoji bbcode.
  static const String code = 'code';
}

/// Info on an emoji node.
final class BBCodeEmojiInfo {
  /// Constructor.
  const BBCodeEmojiInfo(this.code);

  /// BBCode.
  final String code;

  Map<String, dynamic> toJson() => {
        BBCodeEmojiKeys.code: code,
      };

  static BBCodeEmojiInfo fromJson(Map<String, dynamic> json) {
    final code = switch (json) {
      {BBCodeEmojiKeys.code: final String data} => data,
      _ => null,
    };

    assert(code != null, 'Emoji node MUST have bbcode value');

    return BBCodeEmojiInfo(code ?? '');
  }
}
