/// All bbcode tag definition.
sealed class BBCode {
  /// Constructor.
  const BBCode({
    required this.tag,
    required this.attribute,
    required this.content,
  });

  /// Tag name
  ///
  /// For a tag:
  ///
  /// ```
  /// [foo=bar]baz[/foo]
  /// ```
  ///
  /// [tag] is the `foo`.
  final String tag;

  /// Attribute string.
  ///
  /// For a tag:
  ///
  /// ```
  /// [foo=bar]baz[/foo]
  /// ```
  /// [attribute] is the `bar`.
  ///
  /// This field is optional:
  ///
  /// ```
  /// [foo]baz[/foo]
  /// ```
  /// is also valid.
  final String attribute;

  /// Content in the tag.
  ///
  /// For a tag:
  ///
  /// ```
  /// [foo=bar]baz[/foo]
  /// ```
  ///
  /// [content] is the `bar`.
  final String content;
}
