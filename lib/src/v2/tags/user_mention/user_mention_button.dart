import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/flutter_bbcode_editor.dart';
import 'package:flutter_bbcode_editor/src/l10n/l10n_widget.dart';
import 'package:flutter_bbcode_editor/src/v2/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/v2/tags/user_mention/user_mention_keys.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/translations.dart';

class _PickUserMentionDialog extends StatefulWidget {
  const _PickUserMentionDialog({this.username, super.key});

  final String? username;
  @override
  State<_PickUserMentionDialog> createState() => _PickUserMentionDialogState();
}

class _PickUserMentionDialogState extends State<_PickUserMentionDialog> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.username);
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.bbcodeL10n;
    return AlertDialog(
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: usernameController,
          autofocus: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person),
            labelText: tr.userMentionDialogUsername,
          ),
          validator: (v) => v == null || v.trim().isEmpty
              ? tr.userMentionDialogEmptyUsername
              : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (formKey.currentState == null ||
                !(formKey.currentState!).validate()) {
              return;
            }
            Navigator.of(context).pop(usernameController.text);
          },
          child: Text(context.loc.ok),
        ),
      ],
    );
  }
}

/// User mention button in toolbar.
class BBCodeEditorToolbarUserMentionButtonOptions
    extends QuillToolbarCustomButtonOptions {
  /// Constructor.
  const BBCodeEditorToolbarUserMentionButtonOptions({
    /// Callback when button pressed.
    required super.onPressed,
    super.icon,
    super.iconTheme,
    super.tooltip,
    super.afterButtonPressed,
  });

  static Future<void> openUserMentionDialog(
    BuildContext context,
    BBCodeEditorController controller,
  ) async {
    final username = await showDialog<String>(
      context: context,
      builder: (_) => const BBCodeLocalizationsWidget(
        child: FlutterQuillLocalizationsWidget(
          child: _PickUserMentionDialog(),
        ),
      ),
    );
    if (username == null) {
      return;
    }

    controller.insertFormattedText(
      // Remove `@` when converting to bbcode.
      '@$username',
      UserMentionAttribute(username: username),
    );
  }

  // Widget build(BuildContext context) {
  //   return QuillToolbarIconButton(
  //     icon: const Icon(Icons.alternate_email),
  //     tooltip: context.bbcodeL10n.userMention,
  //     isSelected: false,
  //     iconTheme: context.quillToolbarBaseButtonOptions?.iconTheme,
  //     onPressed: () async => _openUserMentionDialog(context),
  //   );
  // }
}
