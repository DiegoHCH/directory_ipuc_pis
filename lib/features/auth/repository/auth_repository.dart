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

  /// Traduce errores de email/password a mensajes claros.
  String friendlyAuthError(FirebaseAuthException e) => switch (e.code) {
        'email-already-in-use' =>
          'Ese correo ya está registrado. Inicia sesión.',
        'invalid-email' => 'El correo no es válido.',
        'weak-password' => 'La contraseña debe tener al menos 6 caracteres.',
        'wrong-password' || 'invalid-credential' =>
          'Correo o contraseña incorrectos.',
        'user-not-found' => 'No existe una cuenta con ese correo.',
        'network-request-failed' =>
          'Sin conexión. Revisa tu internet e intenta de nuevo.',
        _ => 'No se pudo completar. Intenta más tarde.',
      };

  Future<void> signOut() => _auth.signOut();
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(FirebaseAuth.instance),
);

/// Stream del usuario autenticado actual (null si no hay sesión).
final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);
