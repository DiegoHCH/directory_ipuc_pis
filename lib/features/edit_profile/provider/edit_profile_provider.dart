import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final String businessName;
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
    required this.businessName,
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
        businessName: m.description,
        category: m.category == MemberCategory.all
            ? MemberCategory.emprendimiento
            : m.category,
        offers: List.from(m.offers),
        visible: m.visible,
        photoUrl: m.photoUrl,
      );

  bool get isDirty =>
      name != original.name ||
      businessName != original.description ||
      category != original.category ||
      !visible ||
      photoUrl != original.photoUrl ||
      offers.length != original.offers.length ||
      !offers.every(original.offers.contains);

  EditProfileState copyWith({
    String? name,
    String? businessName,
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
        businessName: businessName ?? this.businessName,
        category: category ?? this.category,
        offers: offers ?? this.offers,
        visible: visible ?? this.visible,
        isSaving: isSaving ?? this.isSaving,
        isUploadingPhoto: isUploadingPhoto ?? this.isUploadingPhoto,
        photoUrl: photoUrl ?? this.photoUrl,
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

  /// Elimina todos los datos del usuario y su cuenta de Auth.
  Future<bool> delete() async {
    state = state.copyWith(isSaving: true, errorMessage: null);
    try {
      final uid = state.original.id;
      final db = FirebaseFirestore.instance;

      // 1. Borrar vistas del perfil
      final views = await db
          .collection('profile_views')
          .where('memberId', isEqualTo: uid)
          .get();

      // 2. Borrar eventos de contacto
      final contacts = await db
          .collection('contact_events')
          .where('toId', isEqualTo: uid)
          .get();

      // 3. Batch delete de Firestore
      final batch = db.batch();
      for (final doc in [...views.docs, ...contacts.docs]) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // 4. Borrar documento del miembro
      await ref.read(memberRepositoryProvider).delete(uid);

      // 5. Borrar cuenta de Firebase Auth
      await ref.read(authRepositoryProvider).deleteAccount();

      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: e.code == 'requires-recent-login'
            ? 'errReauthRequired'
            : 'errDeleteProfile',
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'errDeleteProfile',
      );
      return false;
    }
  }

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

final editProfileProvider = AutoDisposeNotifierProvider.family<
    EditProfileNotifier, EditProfileState, Member>(EditProfileNotifier.new);
