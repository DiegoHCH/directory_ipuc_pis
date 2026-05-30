import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/auth_repository.dart';

class LoginState {
  final String email;
  final String password;
  final bool isSubmitting;
  final String? errorMessage;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isSubmitting = false,
    this.errorMessage,
  });

  bool get isValid => email.trim().isNotEmpty && password.isNotEmpty;

  LoginState copyWith({
    String? email,
    String? password,
    bool? isSubmitting,
    String? errorMessage,
  }) =>
      LoginState(
        email: email ?? this.email,
        password: password ?? this.password,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        errorMessage: errorMessage,
      );
}

class LoginNotifier extends AutoDisposeNotifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void setEmail(String v) => state = state.copyWith(email: v);
  void setPassword(String v) => state = state.copyWith(password: v);

  Future<bool> submit() async {
    if (!state.isValid) return false;

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      await ref.read(authRepositoryProvider).signInWithEmail(
            email: state.email.trim(),
            password: state.password,
          );
      state = state.copyWith(isSubmitting: false);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: ref.read(authRepositoryProvider).friendlyAuthError(e),
      );
      return false;
    } catch (e, stack) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'No se pudo iniciar sesión. Intenta de nuevo.',
      );
      return false;
    }
  }
}

final loginProvider =
    AutoDisposeNotifierProvider<LoginNotifier, LoginState>(LoginNotifier.new);
