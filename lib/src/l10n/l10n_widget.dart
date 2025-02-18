import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/l10n/generated/bbcode_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Wrap localizations.
class BBCodeLocalizationsWidget extends StatelessWidget {
  /// Constructor.
  const BBCodeLocalizationsWidget({required this.child, super.key});

  /// Child widget that use l10n.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bbcodeL10n = BBCodeEditorLocalizations.of(context);
    if (bbcodeL10n != null) {
      // Already enabled.
      return child;
    }

    return Localizations(
      locale: Localizations.localeOf(context),
      delegates: const [
        ...BBCodeEditorLocalizations.localizationsDelegates,
        ...FlutterQuillLocalizations.localizationsDelegates,
      ],
      child: child,
    );
  }
}
