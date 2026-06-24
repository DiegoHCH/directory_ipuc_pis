import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('es'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Directory IPUC'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Connecting our community'**
  String get appTagline;

  /// No description provided for @btnSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get btnSave;

  /// No description provided for @btnCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btnCancel;

  /// No description provided for @btnDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get btnDelete;

  /// No description provided for @btnEdit.
  ///
  /// In en, this message translates to:
  /// **'EDIT'**
  String get btnEdit;

  /// No description provided for @btnAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get btnAdd;

  /// No description provided for @btnSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get btnSignIn;

  /// No description provided for @btnSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get btnSignUp;

  /// No description provided for @btnNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get btnNotNow;

  /// No description provided for @btnCreateProfile.
  ///
  /// In en, this message translates to:
  /// **'Create my profile'**
  String get btnCreateProfile;

  /// No description provided for @btnEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit my profile'**
  String get btnEditProfile;

  /// No description provided for @btnDeleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Delete my profile'**
  String get btnDeleteProfile;

  /// No description provided for @btnActivateNotifications.
  ///
  /// In en, this message translates to:
  /// **'Activate notifications'**
  String get btnActivateNotifications;

  /// No description provided for @btnAddService.
  ///
  /// In en, this message translates to:
  /// **'Add service'**
  String get btnAddService;

  /// No description provided for @btnContactWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Contact via WhatsApp'**
  String get btnContactWhatsApp;

  /// No description provided for @btnChangePhoto.
  ///
  /// In en, this message translates to:
  /// **'CHANGE PHOTO'**
  String get btnChangePhoto;

  /// No description provided for @btnUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'UPLOAD PHOTO'**
  String get btnUploadPhoto;

  /// No description provided for @btnUploading.
  ///
  /// In en, this message translates to:
  /// **'UPLOADING...'**
  String get btnUploading;

  /// No description provided for @dirTitle.
  ///
  /// In en, this message translates to:
  /// **'Directory'**
  String get dirTitle;

  /// No description provided for @dirSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Members.'**
  String get dirSubtitle;

  /// No description provided for @dirChurch.
  ///
  /// In en, this message translates to:
  /// **'IGLESIA PENTECOSTAL UNIDA DE COLOMBIA'**
  String get dirChurch;

  /// No description provided for @dirChurchShort.
  ///
  /// In en, this message translates to:
  /// **'IPUC Pisarreal'**
  String get dirChurchShort;

  /// No description provided for @dirQuoteEmpty.
  ///
  /// In en, this message translates to:
  /// **'«One Lord, one faith, one baptism.»'**
  String get dirQuoteEmpty;

  /// No description provided for @dirQuoteWithCount.
  ///
  /// In en, this message translates to:
  /// **'«One Lord, one faith, one baptism.» — {count} members offering their work.'**
  String dirQuoteWithCount(int count);

  /// No description provided for @dirSearch.
  ///
  /// In en, this message translates to:
  /// **'Search by name or service...'**
  String get dirSearch;

  /// No description provided for @dirAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get dirAll;

  /// No description provided for @catAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get catAll;

  /// No description provided for @catEmpresa.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get catEmpresa;

  /// No description provided for @catEmprendimiento.
  ///
  /// In en, this message translates to:
  /// **'Entrepreneurship'**
  String get catEmprendimiento;

  /// No description provided for @catArte.
  ///
  /// In en, this message translates to:
  /// **'Art'**
  String get catArte;

  /// No description provided for @catServicio.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get catServicio;

  /// No description provided for @dirNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get dirNoResults;

  /// No description provided for @dirNoResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try another name or change the category.'**
  String get dirNoResultsSubtitle;

  /// No description provided for @dirBeFirst.
  ///
  /// In en, this message translates to:
  /// **'Be the first'**
  String get dirBeFirst;

  /// No description provided for @dirEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'The directory is empty. Join and share your services with the community.'**
  String get dirEmptySubtitle;

  /// No description provided for @dirErrorLoad.
  ///
  /// In en, this message translates to:
  /// **'Could not load the directory'**
  String get dirErrorLoad;

  /// No description provided for @profilePhone.
  ///
  /// In en, this message translates to:
  /// **'PHONE'**
  String get profilePhone;

  /// No description provided for @profilePhoneVerified.
  ///
  /// In en, this message translates to:
  /// **'PHONE · VERIFIED'**
  String get profilePhoneVerified;

  /// No description provided for @profileWhatTheyOffer.
  ///
  /// In en, this message translates to:
  /// **'WHAT THEY OFFER'**
  String get profileWhatTheyOffer;

  /// No description provided for @profileWhatYouOffer.
  ///
  /// In en, this message translates to:
  /// **'WHAT YOU OFFER'**
  String get profileWhatYouOffer;

  /// No description provided for @profileViews.
  ///
  /// In en, this message translates to:
  /// **'Views this\nweek'**
  String get profileViews;

  /// No description provided for @profileContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts via\nWhatsApp'**
  String get profileContacts;

  /// No description provided for @profileActiveServices.
  ///
  /// In en, this message translates to:
  /// **'Active\nservices'**
  String get profileActiveServices;

  /// No description provided for @profilePublished.
  ///
  /// In en, this message translates to:
  /// **'PUBLISHED'**
  String get profilePublished;

  /// No description provided for @profilePublishedVerified.
  ///
  /// In en, this message translates to:
  /// **'PUBLISHED · VERIFIED'**
  String get profilePublishedVerified;

  /// No description provided for @profileUnderReview.
  ///
  /// In en, this message translates to:
  /// **'UNDER REVIEW'**
  String get profileUnderReview;

  /// No description provided for @profileVerified.
  ///
  /// In en, this message translates to:
  /// **'VERIFIED'**
  String get profileVerified;

  /// No description provided for @profileNew.
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get profileNew;

  /// No description provided for @profileMyProfile.
  ///
  /// In en, this message translates to:
  /// **'MY PROFILE'**
  String get profileMyProfile;

  /// No description provided for @profileCategory.
  ///
  /// In en, this message translates to:
  /// **'CATEGORY'**
  String get profileCategory;

  /// No description provided for @profileServiceLabel.
  ///
  /// In en, this message translates to:
  /// **'BUSINESS OR SERVICE'**
  String get profileServiceLabel;

  /// No description provided for @profileBioLabel.
  ///
  /// In en, this message translates to:
  /// **'DESCRIBE WHAT YOU OFFER'**
  String get profileBioLabel;

  /// No description provided for @profileServicesLabel.
  ///
  /// In en, this message translates to:
  /// **'YOUR SERVICES'**
  String get profileServicesLabel;

  /// No description provided for @profileVisibleLabel.
  ///
  /// In en, this message translates to:
  /// **'Visible in directory'**
  String get profileVisibleLabel;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authWelcomeTitle;

  /// No description provided for @authSignInToEdit.
  ///
  /// In en, this message translates to:
  /// **'Sign in to edit your profile.'**
  String get authSignInToEdit;

  /// No description provided for @authSignInToView.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your profile'**
  String get authSignInToView;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'YOUR EMAIL'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get authPasswordLabel;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'email@example.com'**
  String get authEmailHint;

  /// No description provided for @authPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get authPasswordHint;

  /// No description provided for @authMinPassword.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get authMinPassword;

  /// No description provided for @authNoProfile.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have a profile?'**
  String get authNoProfile;

  /// No description provided for @authSignInPrompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignInPrompt;

  /// No description provided for @regNameLabel.
  ///
  /// In en, this message translates to:
  /// **'YOUR NAME'**
  String get regNameLabel;

  /// No description provided for @regNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get regNameHint;

  /// No description provided for @regPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'YOUR WHATSAPP NUMBER'**
  String get regPhoneLabel;

  /// No description provided for @regCategoryQuestion.
  ///
  /// In en, this message translates to:
  /// **'WHICH CATEGORY FITS YOU?'**
  String get regCategoryQuestion;

  /// No description provided for @regServiceHint.
  ///
  /// In en, this message translates to:
  /// **'E.g.: Birthday cakes'**
  String get regServiceHint;

  /// No description provided for @regBioHint.
  ///
  /// In en, this message translates to:
  /// **'Tell the community what you do...'**
  String get regBioHint;

  /// No description provided for @regNoServices.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t added services yet.'**
  String get regNoServices;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get settingsAppearance;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get settingsNotifications;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get settingsAccount;

  /// No description provided for @settingsThemeAuto.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get settingsThemeAuto;

  /// No description provided for @settingsThemeAutoDesc.
  ///
  /// In en, this message translates to:
  /// **'Follows your phone\'s system'**
  String get settingsThemeAutoDesc;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsNotifyNewMembers.
  ///
  /// In en, this message translates to:
  /// **'Notify me of new members'**
  String get settingsNotifyNewMembers;

  /// No description provided for @settingsNotifyContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts to my profile'**
  String get settingsNotifyContacts;

  /// No description provided for @settingsNotifyContactsDesc.
  ///
  /// In en, this message translates to:
  /// **'Turn it off if you don\'t want to receive contacts for now.'**
  String get settingsNotifyContactsDesc;

  /// No description provided for @settingsMyProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get settingsMyProfile;

  /// No description provided for @settingsHelp.
  ///
  /// In en, this message translates to:
  /// **'Help and support'**
  String get settingsHelp;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacy;

  /// No description provided for @errOpenPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Could not open the privacy policy.'**
  String get errOpenPrivacy;

  /// No description provided for @settingsHelpMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello, I need help with the IPUC Pisarreal Directory 🙏'**
  String get settingsHelpMessage;

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get settingsLanguage;

  /// No description provided for @settingsLangSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get settingsLangSpanish;

  /// No description provided for @settingsLangEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLangEnglish;

  /// No description provided for @settingsFooter.
  ///
  /// In en, this message translates to:
  /// **'Directory Members · v1.0\nIglesia Pentecostal Unida de Colombia\nPisarreal - Los Patios'**
  String get settingsFooter;

  /// No description provided for @notifDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay up to date'**
  String get notifDialogTitle;

  /// No description provided for @notifDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Activate notifications to know when a new member joins the directory.'**
  String get notifDialogBody;

  /// No description provided for @notifNewMember.
  ///
  /// In en, this message translates to:
  /// **'New member in the directory!'**
  String get notifNewMember;

  /// No description provided for @notifNewMemberBody.
  ///
  /// In en, this message translates to:
  /// **'Join the directory and share your services with the community.'**
  String get notifNewMemberBody;

  /// No description provided for @authDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authDialogTitle;

  /// No description provided for @authDialogBody.
  ///
  /// In en, this message translates to:
  /// **'You must sign in to view contact information.'**
  String get authDialogBody;

  /// No description provided for @deleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete profile?'**
  String get deleteDialogTitle;

  /// No description provided for @deleteDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteDialogBody;

  /// No description provided for @successSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved.'**
  String get successSaved;

  /// No description provided for @successSignedOut.
  ///
  /// In en, this message translates to:
  /// **'Session closed.'**
  String get successSignedOut;

  /// No description provided for @successProfileCreated.
  ///
  /// In en, this message translates to:
  /// **'Profile created! Sending invitation via WhatsApp...'**
  String get successProfileCreated;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Connecting our community'**
  String get splashTagline;

  /// No description provided for @errOpenWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'Could not open WhatsApp.'**
  String get errOpenWhatsApp;

  /// No description provided for @errOpenDialer.
  ///
  /// In en, this message translates to:
  /// **'Could not open the dialer.'**
  String get errOpenDialer;

  /// No description provided for @errLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Could not load your profile.'**
  String get errLoadProfile;

  /// No description provided for @errLoadDirectory.
  ///
  /// In en, this message translates to:
  /// **'Could not load the directory'**
  String get errLoadDirectory;

  /// No description provided for @errCreateProfile.
  ///
  /// In en, this message translates to:
  /// **'Could not create profile. Try again.'**
  String get errCreateProfile;

  /// No description provided for @errDeleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Could not delete profile. Try again.'**
  String get errDeleteProfile;

  /// No description provided for @errReauthRequired.
  ///
  /// In en, this message translates to:
  /// **'For security, sign out, sign back in, and try again.'**
  String get errReauthRequired;

  /// No description provided for @errSave.
  ///
  /// In en, this message translates to:
  /// **'Could not save.'**
  String get errSave;

  /// No description provided for @errSignIn.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in. Try again.'**
  String get errSignIn;

  /// No description provided for @errUploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Could not upload photo. Try again.'**
  String get errUploadPhoto;

  /// No description provided for @errSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Could not save changes. Try again.'**
  String get errSaveChanges;

  /// No description provided for @errNoConnection.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your internet and try again.'**
  String get errNoConnection;

  /// No description provided for @errEmailTaken.
  ///
  /// In en, this message translates to:
  /// **'That email is already registered. Sign in.'**
  String get errEmailTaken;

  /// No description provided for @errInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'The email is not valid.'**
  String get errInvalidEmail;

  /// No description provided for @errWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'The password must have at least 6 characters.'**
  String get errWeakPassword;

  /// No description provided for @errWrongCredentials.
  ///
  /// In en, this message translates to:
  /// **'Email or password incorrect.'**
  String get errWrongCredentials;

  /// No description provided for @errUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account exists with that email.'**
  String get errUserNotFound;

  /// No description provided for @errPhoneTaken.
  ///
  /// In en, this message translates to:
  /// **'That number is already registered. If it\'s yours, sign in.'**
  String get errPhoneTaken;

  /// No description provided for @errGeneric.
  ///
  /// In en, this message translates to:
  /// **'Could not complete. Try again later.'**
  String get errGeneric;

  /// No description provided for @errDeleteGeneric.
  ///
  /// In en, this message translates to:
  /// **'Could not delete.'**
  String get errDeleteGeneric;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
