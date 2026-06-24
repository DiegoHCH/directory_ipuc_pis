import '../../l10n/app_localizations.dart';

/// Converts an error key stored in provider state into a localized string.
/// Providers store keys (e.g. 'errSignIn') — never raw text — so this is
/// the single translation point for all provider-originated error messages.
String localizeError(AppLocalizations l10n, String? key) {
  if (key == null || key.isEmpty) return '';
  return switch (key) {
    'errSignIn'         => l10n.errSignIn,
    'errUploadPhoto'    => l10n.errUploadPhoto,
    'errDeleteProfile'  => l10n.errDeleteProfile,
    'errSaveChanges'    => l10n.errSaveChanges,
    'errCreateProfile'  => l10n.errCreateProfile,
    'errEmailTaken'     => l10n.errEmailTaken,
    'errInvalidEmail'   => l10n.errInvalidEmail,
    'errWeakPassword'   => l10n.errWeakPassword,
    'errWrongCredentials' => l10n.errWrongCredentials,
    'errUserNotFound'   => l10n.errUserNotFound,
    'errNoConnection'   => l10n.errNoConnection,
    'errPhoneTaken'     => l10n.errPhoneTaken,
    'errReauthRequired' => l10n.errReauthRequired,
    _                   => l10n.errGeneric,
  };
}
