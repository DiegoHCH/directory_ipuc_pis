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
import '../../../core/widgets/lottie_loader_screen.dart';

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
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                    if (state.password.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.x2),
                      _PasswordRules(password: state.password),
                    ],
                    const SizedBox(height: AppSpacing.x5),
                    _FieldLabel('CONFIRMAR CONTRASEÑA'),
                    const SizedBox(height: AppSpacing.x2),
                    _InputField(
                      controller: _confirmPasswordController,
                      hintText: 'Repite tu contraseña',
                      obscureText: true,
                      onChanged: notifier.setConfirmPassword,
                    ),
                    if (state.confirmPassword.isNotEmpty &&
                        !state.passwordsMatch) ...[
                      const SizedBox(height: AppSpacing.x2),
                      _PasswordMismatch(),
                    ],
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
                        final router = GoRouter.of(context);
                        final successMsg = context.l10n.successProfileCreated;
                        await showLottieLoader(
                          context,
                          task: () => notifier.submit(),
                          onDone: () => router.go('/directory'),
                          successBuilder: (close) => _SuccessSheet(
                            message: successMsg,
                            onContinue: close,
                          ),
                        );
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

class _InputField extends StatefulWidget {
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
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isPassword = widget.obscureText;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.input,
      ),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        maxLines: isPassword ? 1 : widget.maxLines,
        obscureText: isPassword && _hidden,
        keyboardType: widget.keyboardType,
        autocorrect: !isPassword,
        enableSuggestions: !isPassword,
        style: AppTypography.titleLg.copyWith(color: colors.textPrimary),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle:
              AppTypography.titleLg.copyWith(color: colors.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.inputPaddingH,
            vertical: AppSpacing.inputPaddingV,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: colors.textSecondary,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _hidden = !_hidden),
                )
              : null,
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

class _PasswordMismatch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Icon(Icons.error_outline, size: 14, color: colors.error),
        const SizedBox(width: 6),
        Text(
          'Las contraseñas no coinciden',
          style: TextStyle(
            fontSize: AppTypography.sizeXs,
            color: colors.error,
          ),
        ),
      ],
    );
  }
}

class _PasswordRules extends StatelessWidget {
  final String password;

  const _PasswordRules({required this.password});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Rule(
          met: password.length >= 8,
          label: 'Mínimo 8 caracteres',
          colors: colors,
        ),
        _Rule(
          met: password.contains(RegExp(r'[A-Z]')),
          label: 'Al menos una mayúscula',
          colors: colors,
        ),
        _Rule(
          met: password.contains(RegExp(r'[0-9]')),
          label: 'Al menos un número',
          colors: colors,
        ),
      ],
    );
  }
}

class _Rule extends StatelessWidget {
  final bool met;
  final String label;
  final dynamic colors;

  const _Rule({required this.met, required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle_outline : Icons.radio_button_unchecked,
            size: 14,
            color: met ? c.success : c.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: AppTypography.sizeXs,
              color: met ? c.success : c.textSecondary,
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

class _SuccessSheet extends StatelessWidget {
  final String message;
  final VoidCallback onContinue;
  const _SuccessSheet({required this.message, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final padding = MediaQuery.of(context).padding;
    return Material(
      color: colors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: colors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle_outline,
                    color: colors.success, size: 48),
              ),
              const SizedBox(height: AppSpacing.x6),
              Text(
                message,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: AppTypography.size2xl,
                  fontWeight: AppTypography.extrabold,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.textOnPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.button),
                    elevation: 0,
                  ),
                  child: Text(
                    context.l10n.btnContinue,
                    style: const TextStyle(
                        fontSize: AppTypography.sizeLg,
                        fontWeight: AppTypography.semibold),
                  ),
                ),
              ),
              SizedBox(height: padding.bottom > 0 ? 0 : AppSpacing.x4),
            ],
          ),
        ),
      ),
    );
  }
}
