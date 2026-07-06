import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/cloudinary_service.dart';
import '../../../core/services/notification_service.dart';
import '../../auth/repository/auth_repository.dart';
import '../../directory/model/member.dart';
import '../../directory/repository/member_repository.dart';
import '../../settings/provider/settings_provider.dart';

class RegisterState {
  final String name;
  final bool offersServices;
  final String description;
  final MemberCategory? category;
  final String bio;
  final List<String> offers;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;
  final String? photoUrl;
  final bool isUploadingPhoto;
  final bool isSubmitting;
  final String? errorMessage;
  final Member? createdMember;

  const RegisterState({
    this.name = '',
    this.offersServices = true,
    this.description = '',
    this.category,
    this.bio = '',
    this.offers = const [],
    this.phone = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.photoUrl,
    this.isUploadingPhoto = false,
    this.isSubmitting = false,
    this.errorMessage,
    this.createdMember,
  });

  bool get isPasswordStrong =>
      password.length >= 8 &&
      password.contains(RegExp(r'[A-Z]')) &&
      password.contains(RegExp(r'[0-9]'));

  bool get passwordsMatch => password == confirmPassword;

  bool get isValid =>
      name.trim().isNotEmpty &&
      (!offersServices || category != null) &&
      phone.trim().length == 10 &&
      email.trim().isNotEmpty &&
      isPasswordStrong &&
      passwordsMatch &&
      !isUploadingPhoto;

  String get fullPhone => '+57${phone.trim()}';

  RegisterState copyWith({
    String? name,
    bool? offersServices,
    String? description,
    MemberCategory? category,
    String? bio,
    List<String>? offers,
    String? phone,
    String? email,
    String? password,
    String? confirmPassword,
    String? photoUrl,
    bool? isUploadingPhoto,
    bool? isSubmitting,
    String? errorMessage,
    Member? createdMember,
  }) =>
      RegisterState(
        name: name ?? this.name,
        offersServices: offersServices ?? this.offersServices,
        description: description ?? this.description,
        category: category ?? this.category,
        bio: bio ?? this.bio,
        offers: offers ?? this.offers,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        photoUrl: photoUrl ?? this.photoUrl,
        isUploadingPhoto: isUploadingPhoto ?? this.isUploadingPhoto,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        errorMessage: errorMessage,
        createdMember: createdMember ?? this.createdMember,
      );
}

class RegisterNotifier extends AutoDisposeNotifier<RegisterState> {
  @override
  RegisterState build() => const RegisterState();

  void setName(String v) => state = state.copyWith(name: v);
  void setOffersServices(bool v) => state = state.copyWith(offersServices: v);
  void setDescription(String v) => state = state.copyWith(description: v);
  void setCategory(MemberCategory v) => state = state.copyWith(category: v);
  void setBio(String v) => state = state.copyWith(bio: v);
  void setPhone(String v) => state = state.copyWith(phone: v);
  void setEmail(String v) => state = state.copyWith(email: v);
  void setPassword(String v) => state = state.copyWith(password: v);
  void setConfirmPassword(String v) => state = state.copyWith(confirmPassword: v);

  Future<void> pickPhoto() async {
    final picked = await ImagePicker().pickImage(
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
          errorMessage: 'errPhoneTaken',
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
        description: state.offersServices ? state.description.trim() : '',
        phone: state.fullPhone,
        category: state.offersServices ? state.category! : MemberCategory.buscador,
        bio: state.offersServices ? state.bio.trim() : '',
        offers: state.offersServices ? state.offers : const [],
        photoUrl: state.photoUrl,
      );

      final saved = await ref
          .read(memberRepositoryProvider)
          .add(member, uid: credential.user!.uid);

      state = state.copyWith(isSubmitting: false, createdMember: saved);

      // Notificaciones: no bloquean el registro si fallan
      try {
        await ref.read(settingsProvider.notifier).enableContactsNotification();

        final excludeToken = await NotificationService.getCurrentToken();

        await NotificationService.publish(
          title: '¡Nuevo hermano en el directorio!',
          body: '${saved.name} acaba de unirse a la comunidad. 🙏',
          excludeToken: excludeToken,
          excludeUid: credential.user?.uid,
        );
      } catch (_) {}

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
        errorMessage: 'errCreateProfile',
      );
      return false;
    }
  }
}

final registerProvider =
    AutoDisposeNotifierProvider<RegisterNotifier, RegisterState>(
        RegisterNotifier.new);
