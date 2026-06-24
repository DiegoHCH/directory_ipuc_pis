// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Directory IPUC';

  @override
  String get appTagline => 'Connecting our community';

  @override
  String get btnSave => 'Save';

  @override
  String get btnCancel => 'Cancel';

  @override
  String get btnDelete => 'Delete';

  @override
  String get btnEdit => 'EDIT';

  @override
  String get btnAdd => 'Add';

  @override
  String get btnSignIn => 'Sign in';

  @override
  String get btnSignUp => 'Sign up';

  @override
  String get btnNotNow => 'Not now';

  @override
  String get btnCreateProfile => 'Create my profile';

  @override
  String get btnEditProfile => 'Edit my profile';

  @override
  String get btnDeleteProfile => 'Delete my profile';

  @override
  String get btnActivateNotifications => 'Activate notifications';

  @override
  String get btnAddService => 'Add service';

  @override
  String get btnContactWhatsApp => 'Contact via WhatsApp';

  @override
  String get btnChangePhoto => 'CHANGE PHOTO';

  @override
  String get btnUploadPhoto => 'UPLOAD PHOTO';

  @override
  String get btnUploading => 'UPLOADING...';

  @override
  String get dirTitle => 'Directory';

  @override
  String get dirSubtitle => 'Members.';

  @override
  String get dirChurch => 'IGLESIA PENTECOSTAL UNIDA DE COLOMBIA';

  @override
  String get dirChurchShort => 'IPUC Pisarreal';

  @override
  String get dirQuoteEmpty => '«One Lord, one faith, one baptism.»';

  @override
  String dirQuoteWithCount(int count) {
    return '«One Lord, one faith, one baptism.» — $count members offering their work.';
  }

  @override
  String get dirSearch => 'Search by name or service...';

  @override
  String get dirAll => 'All';

  @override
  String get catAll => 'All';

  @override
  String get catEmpresa => 'Business';

  @override
  String get catEmprendimiento => 'Entrepreneurship';

  @override
  String get catArte => 'Art';

  @override
  String get catServicio => 'Service';

  @override
  String get dirNoResults => 'No results';

  @override
  String get dirNoResultsSubtitle => 'Try another name or change the category.';

  @override
  String get dirBeFirst => 'Be the first';

  @override
  String get dirEmptySubtitle =>
      'The directory is empty. Join and share your services with the community.';

  @override
  String get dirErrorLoad => 'Could not load the directory';

  @override
  String get profilePhone => 'PHONE';

  @override
  String get profilePhoneVerified => 'PHONE · VERIFIED';

  @override
  String get profileWhatTheyOffer => 'WHAT THEY OFFER';

  @override
  String get profileWhatYouOffer => 'WHAT YOU OFFER';

  @override
  String get profileViews => 'Views this\nweek';

  @override
  String get profileContacts => 'Contacts via\nWhatsApp';

  @override
  String get profileActiveServices => 'Active\nservices';

  @override
  String get profilePublished => 'PUBLISHED';

  @override
  String get profilePublishedVerified => 'PUBLISHED · VERIFIED';

  @override
  String get profileUnderReview => 'UNDER REVIEW';

  @override
  String get profileVerified => 'VERIFIED';

  @override
  String get profileNew => 'NEW';

  @override
  String get profileMyProfile => 'MY PROFILE';

  @override
  String get profileCategory => 'CATEGORY';

  @override
  String get profileServiceLabel => 'BUSINESS OR SERVICE';

  @override
  String get profileBioLabel => 'DESCRIBE WHAT YOU OFFER';

  @override
  String get profileServicesLabel => 'YOUR SERVICES';

  @override
  String get profileVisibleLabel => 'Visible in directory';

  @override
  String get authWelcomeTitle => 'Welcome back';

  @override
  String get authSignInToEdit => 'Sign in to edit your profile.';

  @override
  String get authSignInToView => 'Sign in to view your profile';

  @override
  String get authEmailLabel => 'YOUR EMAIL';

  @override
  String get authPasswordLabel => 'PASSWORD';

  @override
  String get authEmailHint => 'email@example.com';

  @override
  String get authPasswordHint => 'Your password';

  @override
  String get authMinPassword => 'Minimum 6 characters';

  @override
  String get authNoProfile => 'Don\'t have a profile?';

  @override
  String get authSignInPrompt => 'Sign in';

  @override
  String get regNameLabel => 'YOUR NAME';

  @override
  String get regNameHint => 'Full name';

  @override
  String get regPhoneLabel => 'YOUR WHATSAPP NUMBER';

  @override
  String get regCategoryQuestion => 'WHICH CATEGORY FITS YOU?';

  @override
  String get regServiceHint => 'E.g.: Birthday cakes';

  @override
  String get regBioHint => 'Tell the community what you do...';

  @override
  String get regNoServices => 'You haven\'t added services yet.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'APPEARANCE';

  @override
  String get settingsNotifications => 'NOTIFICATIONS';

  @override
  String get settingsAccount => 'ACCOUNT';

  @override
  String get settingsThemeAuto => 'Automatic';

  @override
  String get settingsThemeAutoDesc => 'Follows your phone\'s system';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsNotifyNewMembers => 'Notify me of new members';

  @override
  String get settingsNotifyContacts => 'Contacts to my profile';

  @override
  String get settingsNotifyContactsDesc =>
      'Turn it off if you don\'t want to receive contacts for now.';

  @override
  String get settingsMyProfile => 'My profile';

  @override
  String get settingsHelp => 'Help and support';

  @override
  String get settingsPrivacy => 'Privacy policy';

  @override
  String get errOpenPrivacy => 'Could not open the privacy policy.';

  @override
  String get settingsHelpMessage =>
      'Hello, I need help with the IPUC Pisarreal Directory 🙏';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get settingsLanguage => 'LANGUAGE';

  @override
  String get settingsLangSpanish => 'Spanish';

  @override
  String get settingsLangEnglish => 'English';

  @override
  String get settingsFooter =>
      'Directory Members · v1.0\nIglesia Pentecostal Unida de Colombia\nPisarreal - Los Patios';

  @override
  String get notifDialogTitle => 'Stay up to date';

  @override
  String get notifDialogBody =>
      'Activate notifications to know when a new member joins the directory.';

  @override
  String get notifNewMember => 'New member in the directory!';

  @override
  String get notifNewMemberBody =>
      'Join the directory and share your services with the community.';

  @override
  String get authDialogTitle => 'Sign in';

  @override
  String get authDialogBody => 'You must sign in to view contact information.';

  @override
  String get deleteDialogTitle => 'Delete profile?';

  @override
  String get deleteDialogBody => 'This action cannot be undone.';

  @override
  String get successSaved => 'Changes saved.';

  @override
  String get successSignedOut => 'Session closed.';

  @override
  String get successProfileCreated =>
      'Profile created! Welcome to the directory.';

  @override
  String get splashTagline => 'Connecting our community';

  @override
  String get errOpenWhatsApp => 'Could not open WhatsApp.';

  @override
  String get errOpenDialer => 'Could not open the dialer.';

  @override
  String get errLoadProfile => 'Could not load your profile.';

  @override
  String get errLoadDirectory => 'Could not load the directory';

  @override
  String get errCreateProfile => 'Could not create profile. Try again.';

  @override
  String get errDeleteProfile => 'Could not delete profile. Try again.';

  @override
  String get errReauthRequired =>
      'For security, sign out, sign back in, and try again.';

  @override
  String get errSave => 'Could not save.';

  @override
  String get errSignIn => 'Could not sign in. Try again.';

  @override
  String get errUploadPhoto => 'Could not upload photo. Try again.';

  @override
  String get errSaveChanges => 'Could not save changes. Try again.';

  @override
  String get errNoConnection =>
      'No connection. Check your internet and try again.';

  @override
  String get errEmailTaken => 'That email is already registered. Sign in.';

  @override
  String get errInvalidEmail => 'The email is not valid.';

  @override
  String get errWeakPassword => 'The password must have at least 6 characters.';

  @override
  String get errWrongCredentials => 'Email or password incorrect.';

  @override
  String get errUserNotFound => 'No account exists with that email.';

  @override
  String get errPhoneTaken =>
      'That number is already registered. If it\'s yours, sign in.';

  @override
  String get errGeneric => 'Could not complete. Try again later.';

  @override
  String get errDeleteGeneric => 'Could not delete.';
}
