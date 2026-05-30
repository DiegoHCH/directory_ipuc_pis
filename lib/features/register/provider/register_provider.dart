import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../directory/model/member.dart';

class RegisterState {
  final String name;
  final MemberCategory? category;
  final String bio;
  final List<String> offers;
  final String phone;
  final bool isSubmitting;

  const RegisterState({
    this.name = '',
    this.category,
    this.bio = '',
    this.offers = const [],
    this.phone = '',
    this.isSubmitting = false,
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
  }) =>
      RegisterState(
        name: name ?? this.name,
        category: category ?? this.category,
        bio: bio ?? this.bio,
        offers: offers ?? this.offers,
        phone: phone ?? this.phone,
        isSubmitting: isSubmitting ?? this.isSubmitting,
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

  Future<void> submit() async {
    if (!state.isValid) return;
    state = state.copyWith(isSubmitting: true);
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isSubmitting: false);
  }
}

final registerProvider =
    AutoDisposeNotifierProvider<RegisterNotifier, RegisterState>(
        RegisterNotifier.new);
