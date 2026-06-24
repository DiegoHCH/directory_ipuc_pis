import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

  /// Crea una cuenta con correo y contraseña.
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  /// Inicia sesión con correo y contraseña.
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  /// Returns an l10n error key for the given Firebase auth exception.
  /// The key is resolved to a localized string via localizeError().
  String friendlyAuthError(FirebaseAuthException e) => switch (e.code) {
        'email-already-in-use'            => 'errEmailTaken',
        'invalid-email'                   => 'errInvalidEmail',
        'weak-password'                   => 'errWeakPassword',
        'wrong-password' || 'invalid-credential' => 'errWrongCredentials',
        'user-not-found'                  => 'errUserNotFound',
        'network-request-failed'          => 'errNoConnection',
        _                                 => 'errGeneric',
      };

  Future<void> deleteAccount() => _auth.currentUser!.delete();

  Future<void> signOut() => _auth.signOut();
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(FirebaseAuth.instance),
);

/// Stream del usuario autenticado actual (null si no hay sesión).
final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);
