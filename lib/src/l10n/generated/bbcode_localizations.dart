import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'bbcode_localizations_en.dart';
import 'bbcode_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of BBCodeEditorLocalizations
/// returned by `BBCodeEditorLocalizations.of(context)`.
///
/// Applications need to include `BBCodeEditorLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/bbcode_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: BBCodeEditorLocalizations.localizationsDelegates,
///   supportedLocales: BBCodeEditorLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the BBCodeEditorLocalizations.supportedLocales
/// property.
abstract class BBCodeEditorLocalizations {
  BBCodeEditorLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static BBCodeEditorLocalizations? of(BuildContext context) {
    return Localizations.of<BBCodeEditorLocalizations>(
        context, BBCodeEditorLocalizations);
  }

  static const LocalizationsDelegate<BBCodeEditorLocalizations> delegate =
      _BBCodeEditorLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
  ];

  /// No description provided for @imageDialogLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get imageDialogLink;

  /// No description provided for @imageDialogWidth.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get imageDialogWidth;

  /// No description provided for @imageDialogHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get imageDialogHeight;

  /// No description provided for @imageDialogEmptySize.
  ///
  /// In en, this message translates to:
  /// **'Empty size'**
  String get imageDialogEmptySize;

  /// No description provided for @imageDialogInvalidSize.
  ///
  /// In en, this message translates to:
  /// **'Invalid Number'**
  String get imageDialogInvalidSize;

  /// No description provided for @imageBuilderDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Operate Image'**
  String get imageBuilderDialogTitle;

  /// No description provided for @imageBuilderDialogEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get imageBuilderDialogEdit;

  /// No description provided for @imageBuilderDialogDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get imageBuilderDialogDelete;

  /// No description provided for @imageBuilderDialogCopyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy image link'**
  String get imageBuilderDialogCopyLink;

  /// No description provided for @emojiInsertEmoji.
  ///
  /// In en, this message translates to:
  /// **'Insert emoji'**
  String get emojiInsertEmoji;

  /// No description provided for @userMention.
  ///
  /// In en, this message translates to:
  /// **'Mention user'**
  String get userMention;

  /// No description provided for @userMentionDialogUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get userMentionDialogUsername;

  /// No description provided for @userMentionDialogEmptyUsername.
  ///
  /// In en, this message translates to:
  /// **'Username can not be empty'**
  String get userMentionDialogEmptyUsername;

  /// No description provided for @portationTitle.
  ///
  /// In en, this message translates to:
  /// **'Export and import'**
  String get portationTitle;

  /// No description provided for @portationExportBBCode.
  ///
  /// In en, this message translates to:
  /// **'Export BBCode'**
  String get portationExportBBCode;

  /// No description provided for @portationImportBBCode.
  ///
  /// In en, this message translates to:
  /// **'Import BBCode'**
  String get portationImportBBCode;

  /// No description provided for @portationExportQuillDelta.
  ///
  /// In en, this message translates to:
  /// **'Export Quill Delta'**
  String get portationExportQuillDelta;

  /// No description provided for @portationImportQuillDelta.
  ///
  /// In en, this message translates to:
  /// **'Import Quill Delta'**
  String get portationImportQuillDelta;

  /// No description provided for @portationCopyBBCode.
  ///
  /// In en, this message translates to:
  /// **'Copy BBCode to clipboard'**
  String get portationCopyBBCode;

  /// No description provided for @portationCopyQuillDelta.
  ///
  /// In en, this message translates to:
  /// **'Copy Quill Delta to clipboard'**
  String get portationCopyQuillDelta;

  /// No description provided for @portationCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get portationCopiedToClipboard;

  /// No description provided for @portationSelectDirectory.
  ///
  /// In en, this message translates to:
  /// **'Select an output file:'**
  String get portationSelectDirectory;
}

class _BBCodeEditorLocalizationsDelegate
    extends LocalizationsDelegate<BBCodeEditorLocalizations> {
  const _BBCodeEditorLocalizationsDelegate();

  @override
  Future<BBCodeEditorLocalizations> load(Locale locale) {
    return SynchronousFuture<BBCodeEditorLocalizations>(
        lookupBBCodeEditorLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_BBCodeEditorLocalizationsDelegate old) => false;
}

BBCodeEditorLocalizations lookupBBCodeEditorLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return BBCodeEditorLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return BBCodeEditorLocalizationsEn();
    case 'zh':
      return BBCodeEditorLocalizationsZh();
  }

  throw FlutterError(
      'BBCodeEditorLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
