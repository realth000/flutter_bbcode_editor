import 'package:collection/collection.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';
import 'package:flutter_quill/quill_delta.dart';

/// Extension converts [Operation] into raw bbcode.
extension ToBBCodeExt on Operation {
  /// Convert current [Operation] into raw bbcode.
  String toBBCode(BBCodeTagContext context, Set<BBCodeTag> tags) {
    var text = data?.toString() ?? '';
    if (attributes == null) {
      return text;
    }

    print('>>>> content: "$text"');

    // For every attribute, append bbcode head and tail around the raw text.
    for (final entry in attributes!.entries) {
      final attrName = entry.key;
      final attrValue = entry.value;
      final hitTag = tags.firstWhereOrNull((e) => e.quillAttrName == attrName);
      if (hitTag == null) {
        // Unknown tag.
        continue;
      }
      text = hitTag.toBBCode(text, attrValue);
    }

    return text;
  }
}
