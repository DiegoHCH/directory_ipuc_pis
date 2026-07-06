import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/cloudinary_service.dart';
import '../../auth/repository/auth_repository.dart';
import '../../directory/model/member.dart';
import '../../directory/repository/member_repository.dart';

@immutable
class EditProfileState {
  final Member original;
  final String name;
  final bool offersServices;
  final String businessName;
  final String bio;
  final MemberCategory category;
  final List<String> offers;
  final bool visible;
  final bool isSaving;
  final bool isUploadingPhoto;
  final String? photoUrl;
  final String? errorMessage;

  const EditProfileState({
    required this.original,
    required this.name,
    required this.offersServices,
    required this.businessName,
    required this.bio,
    required this.category,
    required this.offers,
    this.visible = true,
    this.isSaving = false,
    this.isUploadingPhoto = false,
    this.photoUrl,
    this.errorMessage,
  });

  factory EditProfileState.fromMember(Member m) => EditProfileState(
        original: m,
        name: m.name,
        offersServices: m.category != MemberCategory.buscador,
        businessName: m.description,
        bio: m.bio,
        category: m.category == MemberCategory.all ||
                m.category == MemberCategory.buscador
            ? MemberCategory.emprendimiento
            : m.category,
        offers: List.from(m.offers),
        visible: m.visible,
        photoUrl: m.photoUrl,
      );

  bool get isDirty =>
      name != original.name ||
      offersServices != (original.category != MemberCategory.buscador) ||
      businessName != original.description ||
      bio != original.bio ||
      category != original.category ||
      !visible ||
      photoUrl != original.photoUrl ||
      offers.length != original.offers.length ||
      !offers.every(original.offers.contains);

  EditProfileState copyWith({
    String? name,
    bool? offersServices,
    String? businessName,
    String? bio,
    MemberCategory? category,
    List<String>? offers,
    bool? visible,
    bool? isSaving,
    bool? isUploadingPhoto,
    String? photoUrl,
    String? errorMessage,
  }) =>
      EditProfileState(
        original: original,
        name: name ?? this.name,
        offersServices: offersServices ?? this.offersServices,
        businessName: businessName ?? this.businessName,
        bio: bio ?? this.bio,
        category: category ?? this.category,
        offers: offers ?? this.offers,
        visible: visible ?? this.visible,
        isSaving: isSaving ?? this.isSaving,
        isUploadingPhoto: isUploadingPhoto ?? this.isUploadingPhoto,
        photoUrl: photoUrl ?? this.photoUrl,
        errorMessage: errorMessage,
      );
}

class EditProfileNotifier extends Notifier<EditProfileState> {
  EditProfileNotifier(this.arg);
  final Member arg;

  @override
  EditProfileState build() => EditProfileState.fromMember(arg);

  void setName(String v) => state = state.copyWith(name: v);
  void setOffersServices(bool v) => state = state.copyWith(offersServices: v);
  void setBusinessName(String v) => state = state.copyWith(businessName: v);
  void setBio(String v) => state = state.copyWith(bio: v);
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

  Future<void> pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (picked == null) return;

    state = state.copyWith(isUploadingPhoto: true, errorMessage: null);
    try {
      final url = await uploadToCloudinary(File(picked.path));
      state = state.copyWith(photoUrl: url, isUploadingPhoto: false);
    } catch (_) {
      state = state.copyWith(
        isUploadingPhoto: false,
        errorMessage: 'errUploadPhoto',
      );
    }
  }

  /// Re-autentica y elimina el perfil de Firestore.
  /// Retorna null si fue exitoso, o la clave de error si falló.
  /// La cuenta de Auth se borra aparte con deleteAuthAccount() DESPUÉS de
  /// navegar, para evitar que authStateChanges desmonte el context activo.
  Future<String?> delete({required String password}) async {
    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      await ref.read(authRepositoryProvider).reauthenticate(password: password);
      await ref.read(memberRepositoryProvider).delete(state.original.id);
      return null;
    } catch (_) {
      state = state.copyWith(isSaving: false, errorMessage: 'errDeleteProfile');
      return 'errDeleteProfile';
    }
  }

  /// Guarda los cambios en Firestore. Retorna true si fue exitoso.
  Future<bool> save() async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final updated = state.original.copyWith(
        name: state.name.trim(),
        description: state.offersServices ? state.businessName.trim() : '',
        bio: state.offersServices ? state.bio.trim() : '',
        category: state.offersServices ? state.category : MemberCategory.buscador,
        offers: state.offersServices ? state.offers : const [],
        visible: state.visible,
        photoUrl: state.photoUrl,
      );

      await ref.read(memberRepositoryProvider).update(updated);

      state = state.copyWith(isSaving: false);
      return true;
    } catch (e, _) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'errSaveChanges',
      );
      return false;
    }
  }
}

final editProfileProvider = NotifierProvider.autoDispose.family<
    EditProfileNotifier, EditProfileState, Member>(EditProfileNotifier.new);
