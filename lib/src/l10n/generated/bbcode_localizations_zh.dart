import 'bbcode_localizations.dart';

/// The translations for Chinese (`zh`).
class BBCodeEditorLocalizationsZh extends BBCodeEditorLocalizations {
  BBCodeEditorLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get imageDialogLink => '链接';

  @override
  String get imageDialogWidth => '宽度';

  @override
  String get imageDialogHeight => '高度';

  @override
  String get imageDialogEmptySize => '大小为空';

  @override
  String get imageDialogInvalidSize => '无效的数字';

  @override
  String get imageBuilderDialogTitle => '操作图片';

  @override
  String get imageBuilderDialogEdit => '编辑';

  @override
  String get imageBuilderDialogDelete => '删除';

  @override
  String get imageBuilderDialogCopyLink => '复制图片链接';

  @override
  String get emojiInsertEmoji => '插入表情';

  @override
  String get userMention => '提醒用户';

  @override
  String get userMentionDialogUsername => '用户名';

  @override
  String get userMentionDialogEmptyUsername => '用户名不能为空';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class BBCodeEditorLocalizationsZhHant extends BBCodeEditorLocalizationsZh {
  BBCodeEditorLocalizationsZhHant() : super('zh_Hant');

  @override
  String get imageDialogLink => '連結';

  @override
  String get imageDialogWidth => '寬度';

  @override
  String get imageDialogHeight => '高度';

  @override
  String get imageDialogEmptySize => '大小為空';

  @override
  String get imageDialogInvalidSize => '無效的數字';

  @override
  String get imageBuilderDialogTitle => '操作圖片';

  @override
  String get imageBuilderDialogEdit => '編輯';

  @override
  String get imageBuilderDialogDelete => '刪除';

  @override
  String get imageBuilderDialogCopyLink => '複製圖片連結';

  @override
  String get emojiInsertEmoji => '插入表情';

  @override
  String get userMention => '提醒使用者';

  @override
  String get userMentionDialogUsername => '使用者名稱';

  @override
  String get userMentionDialogEmptyUsername => '使用者名稱不能為空';
}
