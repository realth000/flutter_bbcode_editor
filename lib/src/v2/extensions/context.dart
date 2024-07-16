import 'package:flutter/cupertino.dart';
import 'package:flutter_bbcode_editor/src/l10n/generated/bbcode_localizations.dart'
    as generated;

typedef BBCodeL10n = generated.BBCodeEditorLocalizations;

/// BBCode l10n methods.
extension BBCodeL10nExt on BuildContext {
  /// Get l10n on current context.
  BBCodeL10n get bbcodeL10n {
    return BBCodeL10n.of(this)!;
  }
}
