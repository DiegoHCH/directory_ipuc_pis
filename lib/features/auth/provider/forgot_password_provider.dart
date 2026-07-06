import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/auth_repository.dart';

class ForgotPasswordState {
  final String email;
  final bool isSubmitting;
  final bool emailSent;
  final String? errorMessage;

  const ForgotPasswordState({
    this.email = '',
    this.isSubmitting = false,
    this.emailSent = false,
    this.errorMessage,
  });

  bool get isValid => email.trim().isNotEmpty;

  ForgotPasswordState copyWith({
    String? email,
    bool? isSubmitting,
    bool? emailSent,
    String? errorMessage,
  }) =>
      ForgotPasswordState(
        email: email ?? this.email,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        emailSent: emailSent ?? this.emailSent,
        errorMessage: errorMessage,
      );
}

class ForgotPasswordNotifier extends Notifier<ForgotPasswordState> {
  @override
  ForgotPasswordState build() => const ForgotPasswordState();

  void setEmail(String v) => state = state.copyWith(email: v);

  Future<bool> submit() async {
    if (!state.isValid) return false;

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(
            email: state.email.trim(),
          );
      state = state.copyWith(isSubmitting: false, emailSent: true);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: ref.read(authRepositoryProvider).friendlyAuthError(e),
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'errGeneric',
      );
      return false;
    }
  }
}

final forgotPasswordProvider =
    NotifierProvider.autoDispose<ForgotPasswordNotifier, ForgotPasswordState>(
        ForgotPasswordNotifier.new);
