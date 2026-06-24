import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../provider/register_provider.dart';
import 'widgets/category_selector.dart';
import 'widgets/offers_input.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/utils/l10n_errors.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _bioController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.x5, AppSpacing.x2, AppSpacing.x5, AppSpacing.x6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.profileNew,
                            style: AppTypography.displayLg.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          Text(
                            context.l10n.dirSubtitle,
                            style: AppTypography.displayLg.copyWith(
                              color: colors.primary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x2),
                          Text(
                            context.l10n.dirEmptySubtitle,
                            style: AppTypography.bodySm.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x6),
                    ZoomIn(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 500),
                      child: const _PhotoUploader(),
                    ),
                    const SizedBox(height: AppSpacing.x6),
                    FadeInLeft(
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 400),
                      child: _FieldLabel(context.l10n.regNameLabel),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    _InputField(
                      controller: _nameController,
                      hintText: context.l10n.regNameHint,
                      onChanged: notifier.setName,
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    _FieldLabel(context.l10n.profileServiceLabel),
                    const SizedBox(height: AppSpacing.x2),
                    _InputField(
                      controller: _descriptionController,
                      hintText: context.l10n.profileServiceHint,
                      onChanged: notifier.setDescription,
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    _FieldLabel(context.l10n.regCategoryQuestion),
                    const SizedBox(height: 10),
                    CategorySelector(
                      selected: state.category,
                      onSelected: notifier.setCategory,
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    _FieldLabel(context.l10n.profileBioLabel),
                    const SizedBox(height: AppSpacing.x2),
                    _InputField(
                      controller: _bioController,
                      hintText: context.l10n.regBioHint,
                      maxLines: 4,
                      onChanged: notifier.setBio,
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    _FieldLabel(context.l10n.profileServicesLabel),
                    const SizedBox(height: 10),
                    OffersInput(
                      offers: state.offers,
                      onAdd: notifier.addOffer,
                      onRemove: notifier.removeOffer,
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    _FieldLabel(context.l10n.regPhoneLabel),
                    const SizedBox(height: AppSpacing.x2),
                    _PhoneField(
                      controller: _phoneController,
                      onChanged: notifier.setPhone,
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    _FieldLabel(context.l10n.authEmailLabel),
                    const SizedBox(height: AppSpacing.x2),
                    _InputField(
                      controller: _emailController,
                      hintText: context.l10n.authEmailHint,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: notifier.setEmail,
                    ),
                    const SizedBox(height: AppSpacing.x5),
                    _FieldLabel(context.l10n.authPasswordLabel),
                    const SizedBox(height: AppSpacing.x2),
                    _InputField(
                      controller: _passwordController,
                      hintText: context.l10n.authMinPassword,
                      obscureText: true,
                      onChanged: notifier.setPassword,
                    ),
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: AppSpacing.x4),
                      _ErrorBanner(
                          message:
                              localizeError(context.l10n, state.errorMessage)),
                    ],
                    const SizedBox(height: AppSpacing.x7),
                    _SubmitButton(
                      isValid: state.isValid,
                      isSubmitting: state.isSubmitting,
                      onSubmit: () async {
                        final ok = await notifier.submit();
                        if (!context.mounted) return;
                        if (ok) {
                          context.go('/directory');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.l10n.successProfileCreated),
                              backgroundColor: context.colors.success,
                            ),
                          );
                        }
                      },
                    ),
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

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4, vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: AppSpacing.iconButtonSize,
                height: AppSpacing.iconButtonSize,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.iconButton,
                ),
                child: Icon(Icons.chevron_left,
                    color: colors.textPrimary, size: 22),
              ),
            ),
          ),
          Text(
            context.l10n.dirChurchShort,
            style: TextStyle(
              color: colors.primary,
              fontSize: AppTypography.sizeXs,
              fontWeight: AppTypography.bold,
              letterSpacing: AppTypography.trackingWide,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoUploader extends ConsumerWidget {
  const _PhotoUploader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final photoUrl = ref.watch(registerProvider).photoUrl;
    final isUploading = ref.watch(registerProvider).isUploadingPhoto;

    return Center(
      child: GestureDetector(
        onTap: isUploading
            ? null
            : () => ref.read(registerProvider.notifier).pickPhoto(),
        child: Column(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
                border: Border.all(
                    color: colors.primary.withValues(alpha: 0.4), width: 1.5),
                image: photoUrl != null
                    ? DecorationImage(
                        image: NetworkImage(photoUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: isUploading
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: colors.primary),
                    )
                  : photoUrl == null
                      ? Icon(Icons.camera_alt_outlined,
                          color: colors.primary, size: 28)
                      : null,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              photoUrl != null
                  ? context.l10n.btnChangePhoto
                  : context.l10n.btnUploadPhoto,
              style: TextStyle(
                color: colors.primary,
                fontSize: AppTypography.sizeXs,
                fontWeight: AppTypography.bold,
                letterSpacing: AppTypography.trackingWider,
              ),
            ),
          ],
        ),
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
  final String hintText;
  final int maxLines;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  const _InputField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.maxLines = 1,
    this.obscureText = false,
    this.keyboardType,
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
        maxLines: obscureText ? 1 : maxLines,
        obscureText: obscureText,
        keyboardType: keyboardType,
        autocorrect: !obscureText,
        enableSuggestions: !obscureText,
        style: AppTypography.titleLg.copyWith(color: colors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              AppTypography.titleLg.copyWith(color: colors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.inputPaddingH,
            vertical: AppSpacing.inputPaddingV,
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: colors.errorMuted,
        borderRadius: AppRadius.iconButton,
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colors.error, size: 18),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  color: colors.error, fontSize: AppTypography.sizeMd),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _PhoneField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.input,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.inputPaddingH,
              vertical: AppSpacing.inputPaddingV,
            ),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                    color: colors.textSecondary.withValues(alpha: 0.2)),
              ),
            ),
            child: Text(
              '+57',
              style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: AppTypography.sizeLg,
                  fontWeight: AppTypography.medium),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: AppTypography.titleLg.copyWith(color: colors.textPrimary),
              decoration: InputDecoration(
                hintText: '311 412 8033',
                hintStyle: AppTypography.titleLg
                    .copyWith(color: colors.textSecondary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: AppSpacing.inputPaddingV),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isValid;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const _SubmitButton({
    required this.isValid,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: isValid && !isSubmitting ? onSubmit : null,
        icon: isSubmitting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.check_circle_outline, size: 20),
        label: Text(
          context.l10n.btnCreateProfile,
          style: const TextStyle(
              fontSize: AppTypography.sizeLg,
              fontWeight: AppTypography.semibold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.textOnPrimary,
          disabledBackgroundColor: colors.surface,
          disabledForegroundColor: colors.textSecondary,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
          elevation: 0,
        ),
      ),
    );
  }
}
