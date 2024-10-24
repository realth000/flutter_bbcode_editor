import 'bbcode_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class BBCodeEditorLocalizationsEn extends BBCodeEditorLocalizations {
  BBCodeEditorLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get imageDialogLink => 'Link';

  @override
  String get imageDialogWidth => 'Width';

  @override
  String get imageDialogHeight => 'Height';

  @override
  String get imageDialogEmptySize => 'Empty size';

  @override
  String get imageDialogInvalidSize => 'Invalid Number';

  @override
  String get imageBuilderDialogTitle => 'Operate Image';

  @override
  String get imageBuilderDialogEdit => 'Edit';

  @override
  String get imageBuilderDialogDelete => 'Delete';

  @override
  String get imageBuilderDialogCopyLink => 'Copy image link';

  @override
  String get emojiInsertEmoji => 'Insert emoji';

  @override
  String get userMention => 'Mention user';

  @override
  String get userMentionDialogUsername => 'Username';

  @override
  String get userMentionDialogEmptyUsername => 'Username can not be empty';

  @override
  String get portationTitle => 'Export and import';

  @override
  String get portationExportBBCode => 'Export BBCode';

  @override
  String get portationImportBBCode => 'Import BBCode';

  @override
  String get portationExportQuillDelta => 'Export Quill Delta';

  @override
  String get portationImportQuillDelta => 'Import Quill Delta';

  @override
  String get portationCopyBBCode => 'Copy BBCode to clipboard';

  @override
  String get portationCopyQuillDelta => 'Copy Quill Delta to clipboard';

  @override
  String get portationCopiedToClipboard => 'Copied to clipboard';

  @override
  String get portationSelectDirectory => 'Select an output file:';
}
