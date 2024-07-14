import 'package:collection/collection.dart';
import 'package:flutter_bbcode_editor/src/v2/context.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/tag.dart';
import 'package:flutter_quill/quill_delta.dart';

/// Extension converts [Operation] into raw bbcode.
extension ToBBCodeExt on Operation {
  String _popBlock(
    BBCodeTagContext context,
    String text, {
    bool alwaysPrependHead = false,
  }) {
    // Contains '\n' and not only '\n'.
    // The text after last '\n' is inside the last block type in context.
    final innerBlockTag = context.insideBlockTagSet.removeLast();

    final String notAffected;
    final String affected;

    final cutPos = text.lastIndexOf('\n');
    if (cutPos == text.length - 1) {
      // Empty affected string.
      //
      // ```bbcode
      // '\n'[quote][b]bold_text[/b][/quote]
      // ```
      notAffected = text.substring(0, cutPos);
      affected =
          innerBlockTag.prependBBCodeHead(innerBlockTag.appendBBCodeTail(text));
    } else if (cutPos == 0) {
      notAffected = '';
      affected = innerBlockTag.prependBBCodeHead(text);
    } else if (text.isEmpty || text == '\n') {
      notAffected = '';
      affected = '';
    } else if (alwaysPrependHead && cutPos >= 0) {
      notAffected = text.substring(0, cutPos);
      affected = innerBlockTag.prependBBCodeHead(text.substring(cutPos + 1));
    } else if (!alwaysPrependHead && cutPos < 0) {
      notAffected = text;
      affected = innerBlockTag.prependBBCodeHead('');
    } else if (cutPos < 0) {
      notAffected = '';
      affected = innerBlockTag.prependBBCodeHead(text);
    } else {
      // ```bbcode
      // foo'\n'[quote][b]bold_text[/b][/quote]
      // ```
      notAffected = text.substring(0, cutPos);
      affected = innerBlockTag.prependBBCodeHead(text.substring(cutPos + 1));
    }

    return notAffected + affected;
  }

  /// Convert current [Operation] into raw bbcode.
  String toBBCode(
    BBCodeTagContext context,
    Set<BBCodeTag> tags, {
    bool removeLastLineFeed = false,
    bool popAllBlock = false,
  }) {
    var text = data?.toString() ?? '';

    if (removeLastLineFeed && text.endsWith('\n')) {
      if (text == '\n') {
        text = '';
      } else {
        text = text.substring(0, text.length - 1);
      }
    }

    final incomingBlockTag = <BBCodeTag>{};

    // For every attribute, append bbcode head and tail around the raw text.
    for (final entry in (attributes ?? {}).entries) {
      final attrName = entry.key;
      final attrValue = entry.value;
      final hitTag = tags.firstWhereOrNull(
        (e) => e.quillAttrName == attrName && e.validateAttribute(attrValue),
      );
      if (hitTag == null) {
        // Unknown tag.
        continue;
      }

      // If is block tag, push into state.
      if (hitTag.isBlockTag) {
        incomingBlockTag.add(hitTag);
        // Usually we have:
        //
        // {
        //   "insert": "\n",
        //   "attributes": {
        //     "blockquote": true
        //   }
        // }
        //
        // when reach the tail of block tags.
        // This standalone "\n" should be removed;
        if (text == '\n' || text == '') {
          text = hitTag.appendBBCodeTail('');
        } else {
          // Not likely this branch.
          //
          // Have something else except '\n'.
          //
          // {
          //   "insert": "some else\n",
          //   "attributes": {
          //     "blockquote": true
          //   }
          // }
          //
          // Remove the last '\n' before convert to bbcode.
          text = hitTag.toBBCode(text.substring(0, text.length - 1), attrValue);
        }
      } else {
        text = hitTag.toBBCode(text, attrValue);
      }
    }

    if (context.insideBlockTagSet.isNotEmpty) {
      // We are in some block tags.
      //
      // Usually we have no attribute on current node if we are here.
      // Means `text` is not modified in the above for loop.
      text = _popBlock(context, text, alwaysPrependHead: popAllBlock);
    }

    // Apply transforms of all current applying block tag style.
    for (final inBlockTag in context.insideBlockTagSet) {
      text = inBlockTag.inBlockTransformer(text);
    }

    if (popAllBlock) {
      while (context.insideBlockTagSet.isNotEmpty) {
        text = _popBlock(context, text, alwaysPrependHead: true);
      }
    }

    context.insideBlockTagSet.addAll(incomingBlockTag);

    return text;
  }
}
