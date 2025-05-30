import 'package:flutter/material.dart';
import 'package:flutter_bbcode_editor/src/editor.dart';
import 'package:flutter_bbcode_editor/src/extensions/context.dart';
import 'package:flutter_bbcode_editor/src/l10n/l10n_widget.dart';
import 'package:flutter_bbcode_editor/src/tags/user_mention/user_mention_embed.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/internal.dart';

/// External function to get a username.
///
/// Used when want to mention someone.
///
/// The default picker is a simple dialog that allows user to enter username.
/// With this injected picker, more convenient features can be used.
///
/// [username] is an optional initial username if user is going to edit an
/// existing username block in editor.
typedef BBCodeUsernamePicker = Future<String?> Function(BuildContext context, {String? username});

/// Default dialog to pick user name working for the user mention feature.
class PickUserMentionDialog extends StatefulWidget {
  /// Constructor.
  const PickUserMentionDialog({this.username, super.key});

  /// Initial username.
  ///
  /// This dialog may be constructed when user tapping a user mention embed
  /// widget in editor. In this situation it's not creating a new embed, instead
  /// modifying an existing one. So here is an existing username saved in this
  /// field.
  final String? username;

  @override
  State<PickUserMentionDialog> createState() => _PickUserMentionDialogState();
}

class _PickUserMentionDialogState extends State<PickUserMentionDialog> {
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
          decoration: InputDecoration(prefixIcon: const Icon(Icons.person), labelText: tr.userMentionDialogUsername),
          validator: (v) => v == null || v.trim().isEmpty ? tr.userMentionDialogEmptyUsername : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (formKey.currentState == null || !(formKey.currentState!).validate()) {
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
class BBCodeEditorToolbarUserMentionButton extends StatelessWidget {
  /// Constructor.
  const BBCodeEditorToolbarUserMentionButton({
    /// Callback when button pressed.
    required this.controller,
    this.afterPressed,
    this.usernamePicker,
    super.key,
  });

  /// Injected editor controller.
  final BBCodeEditorController controller;

  /// Optional username picker that provide the username to mention.
  final BBCodeUsernamePicker? usernamePicker;

  /// Callback after button pressed.
  final void Function()? afterPressed;

  @override
  Widget build(BuildContext context) {
    return QuillToolbarIconButton(
      icon: const Icon(Icons.alternate_email),
      tooltip: context.bbcodeL10n.userMention,
      isSelected: false,
      iconTheme: const QuillIconTheme(),
      onPressed: () async {
        String? username;
        if (usernamePicker != null) {
          username = await usernamePicker!.call(context);
        } else {
          username = await showDialog<String>(
            context: context,
            builder:
                (_) =>
                    const BBCodeLocalizationsWidget(child: BBCodeLocalizationsWidget(child: PickUserMentionDialog())),
          );
        }

        if (username == null) {
          return;
        }

        // FIXME: Waiting for upstream fix. check func definition for details.
        controller.insertEmbeddable(BBCodeUserMentionEmbed.raw(username: username));
      },
      afterPressed: afterPressed,
    );
  }
}
