import 'dart:async';

import 'package:flutter_quill/flutter_quill.dart';

/// External function to call when user tap on text with user mention attribute.
typedef BBCodeUserMentionHandler = FutureOr<void> Function(String username);

/// Keys used in user mention style.
class UserMentionAttributeKeys {
  UserMentionAttributeKeys._();

  /// Attribute key.
  static const String key = '@';

  /// Username
  static const String username = 'username';
}

/// User mention attribute.
///
/// ```bbcode
/// [@]$username[/@]
/// ```
final class UserMentionAttribute extends Attribute<String?> {
  /// Constructor.
  const UserMentionAttribute({String? username})
      : super(UserMentionAttributeKeys.key, AttributeScope.inline, username);
}
