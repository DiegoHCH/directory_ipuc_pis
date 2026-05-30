import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../directory/model/member.dart';
import '../../directory/repository/member_repository.dart';

class RegisterState {
  final String name;
  final MemberCategory? category;
  final String bio;
  final List<String> offers;
  final String phone;
  final bool isSubmitting;
  final String? errorMessage;

  const RegisterState({
    this.name = '',
    this.category,
    this.bio = '',
    this.offers = const [],
    this.phone = '',
    this.isSubmitting = false,
    this.errorMessage,
  });

  bool get isValid =>
      name.trim().isNotEmpty &&
      category != null &&
      phone.trim().isNotEmpty;

  RegisterState copyWith({
    String? name,
    MemberCategory? category,
    String? bio,
    List<String>? offers,
    String? phone,
    bool? isSubmitting,
    String? errorMessage,
  }) =>
      RegisterState(
        name: name ?? this.name,
        category: category ?? this.category,
        bio: bio ?? this.bio,
        offers: offers ?? this.offers,
        phone: phone ?? this.phone,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        errorMessage: errorMessage,
      );
}

class RegisterNotifier extends AutoDisposeNotifier<RegisterState> {
  @override
  RegisterState build() => const RegisterState();

  void setName(String v) => state = state.copyWith(name: v);
  void setCategory(MemberCategory v) => state = state.copyWith(category: v);
  void setBio(String v) => state = state.copyWith(bio: v);
  void setPhone(String v) => state = state.copyWith(phone: v);

  void addOffer(String v) {
    final t = v.trim();
    if (t.isEmpty || state.offers.contains(t)) return;
    state = state.copyWith(offers: [...state.offers, t]);
  }

  void removeOffer(String v) =>
      state = state.copyWith(
          offers: state.offers.where((o) => o != v).toList());

  /// Guarda el miembro en Firestore y retorna true si fue exitoso.
  Future<bool> submit() async {
    if (!state.isValid) return false;

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final member = Member(
        id: '',
        name: state.name.trim(),
        description: '',
        phone: '+57${state.phone.trim()}',
        category: state.category!,
        bio: state.bio.trim(),
        offers: state.offers,
      );

      await ref.read(memberRepositoryProvider).add(member);
      return true;
    } catch (e, stack) {
      debugPrint('❌ RegisterNotifier.submit error: $e');
      debugPrint(stack.toString());
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'No se pudo guardar. Intenta de nuevo.',
      );
      return false;
    }
  }
}

final registerProvider =
    AutoDisposeNotifierProvider<RegisterNotifier, RegisterState>(
        RegisterNotifier.new);
