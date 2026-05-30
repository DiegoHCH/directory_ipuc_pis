import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../directory/model/member.dart';

@immutable
class EditProfileState {
  final Member original;
  final String name;
  final String businessName;
  final MemberCategory category;
  final List<String> offers;
  final bool visible;
  final bool isSaving;

  const EditProfileState({
    required this.original,
    required this.name,
    required this.businessName,
    required this.category,
    required this.offers,
    this.visible = true,
    this.isSaving = false,
  });

  factory EditProfileState.fromMember(Member m) => EditProfileState(
        original: m,
        name: m.name,
        businessName: m.description,
        category: m.category == MemberCategory.all
            ? MemberCategory.emprendimiento
            : m.category,
        offers: List.from(m.offers),
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
  }) =>
      EditProfileState(
        original: original,
        name: name ?? this.name,
        businessName: businessName ?? this.businessName,
        category: category ?? this.category,
        offers: offers ?? this.offers,
        visible: visible ?? this.visible,
        isSaving: isSaving ?? this.isSaving,
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

  Future<void> save() async {
    state = state.copyWith(isSaving: true);
    await Future.delayed(const Duration(milliseconds: 800));
    state = state.copyWith(isSaving: false);
  }
}

final editProfileProvider = AutoDisposeNotifierProvider.family<
    EditProfileNotifier, EditProfileState, Member>(EditProfileNotifier.new);
