import 'package:flutter_bbcode_editor/src/tags/spoiler_v2/spoiler_v2_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Header part of v2 version of spoiler.
///
/// Header is a text block on text, setting header types.
class SpoilerV2HeaderAttribute extends Attribute<bool> {
  /// Constructor.
  const SpoilerV2HeaderAttribute() : super(BBCodeSpoilerV2Keys.headerType, AttributeScope.block, true);
}

/// Tail of the v2 version spoiler.
class SpoilerV2TailAttribute extends Attribute<bool> {
  /// Constructor.
  const SpoilerV2TailAttribute() : super(BBCodeSpoilerV2Keys.headerType, AttributeScope.block, true);
}
