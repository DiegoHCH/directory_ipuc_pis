import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../directory/model/member.dart';
import '../../directory/repository/member_repository.dart';

@immutable
class EditProfileState {
  final Member original;
  final String name;
  final String businessName;
  final MemberCategory category;
  final List<String> offers;
  final bool visible;
  final bool isSaving;
  final String? errorMessage;

  const EditProfileState({
    required this.original,
    required this.name,
    required this.businessName,
    required this.category,
    required this.offers,
    this.visible = true,
    this.isSaving = false,
    this.errorMessage,
  });

  factory EditProfileState.fromMember(Member m) => EditProfileState(
        original: m,
        name: m.name,
        businessName: m.description,
        category: m.category == MemberCategory.all
            ? MemberCategory.emprendimiento
            : m.category,
        offers: List.from(m.offers),
        visible: m.visible,
      );

  bool get isDirty =>
      name != original.name ||
      businessName != original.description ||
      category != original.category ||
      !visible ||
      offers.length != original.offers.length ||
      !offers.every(original.offers.contains);

  EditProfileState copyWith({
    String? name,
    String? businessName,
    MemberCategory? category,
    List<String>? offers,
    bool? visible,
    bool? isSaving,
    String? errorMessage,
  }) =>
      EditProfileState(
        original: original,
        name: name ?? this.name,
        businessName: businessName ?? this.businessName,
        category: category ?? this.category,
        offers: offers ?? this.offers,
        visible: visible ?? this.visible,
        isSaving: isSaving ?? this.isSaving,
        errorMessage: errorMessage,
      );
}

class EditProfileNotifier
    extends AutoDisposeFamilyNotifier<EditProfileState, Member> {
  @override
  EditProfileState build(Member arg) => EditProfileState.fromMember(arg);

  void setName(String v) => state = state.copyWith(name: v);
  void setBusinessName(String v) => state = state.copyWith(businessName: v);
  void setCategory(MemberCategory v) => state = state.copyWith(category: v);
  void toggleVisibility() => state = state.copyWith(visible: !state.visible);

  void addOffer(String v) {
    final t = v.trim();
    if (t.isEmpty || state.offers.contains(t)) return;
    state = state.copyWith(offers: [...state.offers, t]);
  }

  void removeOffer(String v) =>
      state = state.copyWith(
          offers: state.offers.where((o) => o != v).toList());

  /// Guarda los cambios en Firestore. Retorna true si fue exitoso.
  Future<bool> save() async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final updated = state.original.copyWith(
        name: state.name.trim(),
        description: state.businessName.trim(),
        category: state.category,
        offers: state.offers,
        visible: state.visible,
      );

      await ref.read(memberRepositoryProvider).update(updated);

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e, stack) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'No se pudieron guardar los cambios. Intenta de nuevo.',
      );
      return false;
    }
  }
}

final editProfileProvider = AutoDisposeNotifierProvider.family<
    EditProfileNotifier, EditProfileState, Member>(EditProfileNotifier.new);
