import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/repository/auth_repository.dart';
import '../../directory/model/member.dart';
import '../../directory/repository/member_repository.dart';

class RegisterState {
  final String name;
  final MemberCategory? category;
  final String bio;
  final List<String> offers;
  final String phone;
  final String email;
  final String password;
  final bool isSubmitting;
  final String? errorMessage;
  final Member? createdMember;

  const RegisterState({
    this.name = '',
    this.category,
    this.bio = '',
    this.offers = const [],
    this.phone = '',
    this.email = '',
    this.password = '',
    this.isSubmitting = false,
    this.errorMessage,
    this.createdMember,
  });

  bool get isValid =>
      name.trim().isNotEmpty &&
      category != null &&
      phone.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      password.length >= 6;

  String get fullPhone => '+57${phone.trim()}';

  RegisterState copyWith({
    String? name,
    MemberCategory? category,
    String? bio,
    List<String>? offers,
    String? phone,
    String? email,
    String? password,
    bool? isSubmitting,
    String? errorMessage,
    Member? createdMember,
  }) =>
      RegisterState(
        name: name ?? this.name,
        category: category ?? this.category,
        bio: bio ?? this.bio,
        offers: offers ?? this.offers,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        password: password ?? this.password,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        errorMessage: errorMessage,
        createdMember: createdMember ?? this.createdMember,
      );
}

class RegisterNotifier extends AutoDisposeNotifier<RegisterState> {
  @override
  RegisterState build() => const RegisterState();

  void setName(String v) => state = state.copyWith(name: v);
  void setCategory(MemberCategory v) => state = state.copyWith(category: v);
  void setBio(String v) => state = state.copyWith(bio: v);
  void setPhone(String v) => state = state.copyWith(phone: v);
  void setEmail(String v) => state = state.copyWith(email: v);
  void setPassword(String v) => state = state.copyWith(password: v);

  void addOffer(String v) {
    final t = v.trim();
    if (t.isEmpty || state.offers.contains(t)) return;
    state = state.copyWith(offers: [...state.offers, t]);
  }

  void removeOffer(String v) =>
      state = state.copyWith(
          offers: state.offers.where((o) => o != v).toList());

  /// Crea la cuenta de auth y guarda el perfil en Firestore.
  /// Retorna true si fue exitoso.
  Future<bool> submit() async {
    if (!state.isValid) return false;

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      // 1. Verifica que el número no esté ya registrado.
      final phoneTaken = await ref
          .read(memberRepositoryProvider)
          .phoneExists(state.fullPhone);
      if (phoneTaken) {
        state = state.copyWith(
          isSubmitting: false,
          errorMessage:
              'Ese número ya está registrado. Si es tuyo, inicia sesión.',
        );
        return false;
      }

      // 2. Crea la cuenta (el correo duplicado lo bloquea Firebase).
      final auth = ref.read(authRepositoryProvider);
      final credential = await auth.signUpWithEmail(
        email: state.email.trim(),
        password: state.password,
      );

      final member = Member(
        id: '',
        name: state.name.trim(),
        description: '',
        phone: state.fullPhone,
        category: state.category!,
        bio: state.bio.trim(),
        offers: state.offers,
      );

      final saved = await ref
          .read(memberRepositoryProvider)
          .add(member, uid: credential.user!.uid);

      state = state.copyWith(isSubmitting: false, createdMember: saved);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: ref.read(authRepositoryProvider).friendlyAuthError(e),
      );
      return false;
    } catch (e, _) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'No se pudo crear el perfil. Intenta de nuevo.',
      );
      return false;
    }
  }
}

final registerProvider =
    AutoDisposeNotifierProvider<RegisterNotifier, RegisterState>(
        RegisterNotifier.new);
