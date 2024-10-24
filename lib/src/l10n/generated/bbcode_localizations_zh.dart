import 'bbcode_localizations.dart';

// ignore_for_file: type=lint

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

  @override
  String get portationTitle => '导入和导出';

  @override
  String get portationExportBBCode => '导出为BBCode';

  @override
  String get portationImportBBCode => '导入BBCode';

  @override
  String get portationExportQuillDelta => '导出为Quill Delta';

  @override
  String get portationImportQuillDelta => '导入Quill Delta';

  @override
  String get portationCopyBBCode => '复制BBCode到剪切板';

  @override
  String get portationCopyQuillDelta => '复制Quill Delta到剪切板';

  @override
  String get portationCopiedToClipboard => '已复制到剪切板';

  @override
  String get portationSelectDirectory => '选择一个位置保存：';
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

  @override
  String get portationTitle => '導入與導出';

  @override
  String get portationExportBBCode => '導出為BBCode';

  @override
  String get portationImportBBCode => '導入BBCode';

  @override
  String get portationExportQuillDelta => '導出為Quill Delta';

  @override
  String get portationImportQuillDelta => '導入Quill Delta';

  @override
  String get portationCopyBBCode => '複製 BBCode 到剪貼簿';

  @override
  String get portationCopyQuillDelta => '複製 Quill Delta 到剪貼簿';

  @override
  String get portationCopiedToClipboard => '已複製到剪貼簿';

  @override
  String get portationSelectDirectory => '選擇一個位置儲存：';
}
