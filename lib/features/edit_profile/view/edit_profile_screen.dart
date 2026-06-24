import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/cloudinary_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../directory/model/member.dart';
import '../../register/view/widgets/category_selector.dart';
import '../../register/view/widgets/offers_input.dart';
import '../provider/edit_profile_provider.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/utils/l10n_errors.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final Member member;

  const EditProfileScreen({super.key, required this.member});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _businessController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member.name);
    _businessController =
        TextEditingController(text: widget.member.description);
    _bioController = TextEditingController(text: widget.member.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _businessController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editProfileProvider(widget.member));
    final notifier = ref.read(editProfileProvider(widget.member).notifier);
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x4, vertical: AppSpacing.x3),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: Text(context.l10n.btnCancel,
                          style: AppTypography.titleLg.copyWith(
                              color: colors.textSecondary)),
                    ),
                  ),
                  Text(
                    context.l10n.btnEditProfile,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: AppTypography.sizeXl,
                      fontWeight: AppTypography.semibold,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: state.isSaving || !state.isDirty
                          ? null
                          : () async {
                              final screenContext = context;
                              final ok = await notifier.save();
                              if (!screenContext.mounted) return;
                              if (ok) {
                                screenContext.pop();
                                ScaffoldMessenger.of(screenContext)
                                    .showSnackBar(
                                  SnackBar(
                                    content:
                                        Text(screenContext.l10n.successSaved),
                                    backgroundColor: colors.success,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(screenContext)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(localizeError(
                                        screenContext.l10n,
                                        ref.read(editProfileProvider(widget.member)).errorMessage)),
                                    backgroundColor: colors.error,
                                  ),
                                );
                              }
                            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.x2,
                            vertical: AppSpacing.x2),
                        child: state.isSaving
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: colors.primary),
                              )
                            : Text(
                                context.l10n.btnSave,
                                style: AppTypography.titleLg.copyWith(
                                  color: state.isDirty
                                      ? colors.primary
                                      : colors.textSecondary,
                                  fontWeight: AppTypography.semibold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.x5),
                    Center(child: _AvatarPicker(member: widget.member)),
                    const SizedBox(height: AppSpacing.x6),
                    _FieldLabel(context.l10n.regNameLabel),
                    const SizedBox(height: AppSpacing.x2),
                    _InputField(
                      controller: _nameController,
                      onChanged: notifier.setName,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _FieldLabel(context.l10n.profileServiceLabel),
                    const SizedBox(height: AppSpacing.x2),
                    _InputField(
                      controller: _businessController,
                      onChanged: notifier.setBusinessName,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _FieldLabel(context.l10n.profileCategory),
                    const SizedBox(height: 10),
                    CategorySelector(
                      selected: state.category,
                      onSelected: notifier.setCategory,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _FieldLabel(context.l10n.profileBioLabel),
                    const SizedBox(height: AppSpacing.x2),
                    _InputField(
                      controller: _bioController,
                      onChanged: notifier.setBio,
                      maxLines: 4,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _FieldLabel(context.l10n.profileServicesLabel),
                    const SizedBox(height: 10),
                    OffersInput(
                      offers: state.offers,
                      onAdd: notifier.addOffer,
                      onRemove: notifier.removeOffer,
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    _FieldLabel(context.l10n.profilePhoneVerified),
                    const SizedBox(height: AppSpacing.x2),
                    _PhoneVerifiedField(phone: widget.member.phone),
                    const SizedBox(height: AppSpacing.x4),
                    _VisibilityToggle(
                      visible: state.visible,
                      onToggle: notifier.toggleVisibility,
                    ),
                    const SizedBox(height: AppSpacing.x8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarPicker extends ConsumerWidget {
  final Member member;
  const _AvatarPicker({required this.member});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editProfileProvider(member));
    final notifier = ref.read(editProfileProvider(member).notifier);
    final colors = context.colors;
    final photoUrl = state.photoUrl;

    return GestureDetector(
      onTap: state.isUploadingPhoto ? null : notifier.pickAndUploadPhoto,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.primary, width: 2.5),
                ),
                child: ClipOval(
                  child: state.isUploadingPhoto
                      ? Center(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5, color: colors.primary),
                          ),
                        )
                      : photoUrl != null && photoUrl.isNotEmpty
                          ? Image.network(
                              cloudinaryThumb(photoUrl, size: 172),
                              width: 86,
                              height: 86,
                              fit: BoxFit.cover,
                              errorBuilder: (context, err, stack) => Center(
                                child: Text(
                                  member.initials,
                                  style: TextStyle(
                                    color: colors.primary,
                                    fontSize: 28,
                                    fontWeight: AppTypography.bold,
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                member.initials,
                                style: TextStyle(
                                  color: colors.primary,
                                  fontSize: 28,
                                  fontWeight: AppTypography.bold,
                                ),
                              ),
                            ),
                ),
              ),
              if (!state.isUploadingPhoto)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: colors.background, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt,
                        color: Colors.white, size: 13),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            state.isUploadingPhoto ? context.l10n.btnUploading : context.l10n.btnChangePhoto,
            style: TextStyle(
              color: state.isUploadingPhoto
                  ? colors.textSecondary
                  : colors.primary,
              fontSize: AppTypography.sizeXs,
              fontWeight: AppTypography.bold,
              letterSpacing: AppTypography.trackingWider,
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: context.colors.textSecondary,
        fontSize: AppTypography.sizeXs,
        fontWeight: AppTypography.semibold,
        letterSpacing: AppTypography.trackingWide,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final int maxLines;

  const _InputField({
    required this.controller,
    required this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.input,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: maxLines,
        style: AppTypography.titleLg.copyWith(color: colors.textPrimary),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.inputPaddingH,
            vertical: AppSpacing.inputPaddingV,
          ),
        ),
      ),
    );
  }
}

class _PhoneVerifiedField extends StatelessWidget {
  final String phone;
  const _PhoneVerifiedField({required this.phone});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.inputPaddingH,
        vertical: AppSpacing.inputPaddingV,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.input,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(phone,
                style: AppTypography.titleLg.copyWith(
                    color: colors.textSecondary)),
          ),
          Row(
            children: [
              Icon(Icons.check, color: colors.success, size: 14),
              const SizedBox(width: AppSpacing.x1),
              Text(
                context.l10n.profileVerified,
                style: TextStyle(
                  color: colors.success,
                  fontSize: AppTypography.sizeXs,
                  fontWeight: AppTypography.bold,
                  letterSpacing: AppTypography.trackingNormal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VisibilityToggle extends StatelessWidget {
  final bool visible;
  final VoidCallback onToggle;

  const _VisibilityToggle(
      {required this.visible, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.inputPaddingV,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.button,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.profileVisibleLabel,
                  style: AppTypography.titleLg.copyWith(
                    color: colors.textPrimary,
                    fontWeight: AppTypography.medium,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  context.l10n.settingsNotifyContactsDesc,
                  style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: AppTypography.sizeSm,
                      height: AppTypography.lineHeightSnug),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Switch(
            value: visible,
            onChanged: (_) => onToggle(),
            activeThumbColor: Colors.white,
            activeTrackColor: colors.primary,
          ),
        ],
      ),
    );
  }
}
