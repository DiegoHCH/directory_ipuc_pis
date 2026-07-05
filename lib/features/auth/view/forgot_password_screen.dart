import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../provider/forgot_password_provider.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/utils/l10n_errors.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forgotPasswordProvider);
    final notifier = ref.read(forgotPasswordProvider.notifier);
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.x2),
              GestureDetector(
                onTap: () =>
                    context.canPop() ? context.pop() : context.go('/login'),
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
              const SizedBox(height: AppSpacing.x6),
              if (state.emailSent)
                _SuccessContent(colors: colors)
              else
                FadeInDown(
                  duration: const Duration(milliseconds: 450),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.forgotPasswordTitle,
                        style: AppTypography.displayLg.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x2),
                      Text(
                        context.l10n.forgotPasswordSubtitle,
                        style: AppTypography.bodySm.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              if (!state.emailSent) ...[
                const SizedBox(height: AppSpacing.x8),
                _Label(context.l10n.authEmailLabel),
                const SizedBox(height: AppSpacing.x2),
                _Input(
                  controller: _emailController,
                  hintText: context.l10n.authEmailHint,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: notifier.setEmail,
                ),
                if (state.errorMessage != null) ...[
                  const SizedBox(height: AppSpacing.x4),
                  _ErrorBanner(
                      message:
                          localizeError(context.l10n, state.errorMessage)),
                ],
                const SizedBox(height: AppSpacing.x7),
                SizedBox(
                  width: double.infinity,
                  height: AppSpacing.buttonHeight,
                  child: ElevatedButton(
                    onPressed: state.isValid && !state.isSubmitting
                        ? () => notifier.submit()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.textOnPrimary,
                      disabledBackgroundColor: colors.surface,
                      disabledForegroundColor: colors.textSecondary,
                      shape:
                          RoundedRectangleBorder(borderRadius: AppRadius.button),
                      elevation: 0,
                    ),
                    child: state.isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(context.l10n.btnSendResetLink,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
              ] else ...[
                const SizedBox(height: AppSpacing.x7),
                SizedBox(
                  width: double.infinity,
                  height: AppSpacing.buttonHeight,
                  child: ElevatedButton(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go('/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.textOnPrimary,
                      shape:
                          RoundedRectangleBorder(borderRadius: AppRadius.button),
                      elevation: 0,
                    ),
                    child: Text(context.l10n.btnBackToLogin,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SuccessContent extends StatelessWidget {
  final AppColors colors;
  const _SuccessContent({required this.colors});

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 450),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.mark_email_read_outlined, color: colors.primary, size: 40),
          const SizedBox(height: AppSpacing.x4),
          Text(
            context.l10n.forgotPasswordSuccessTitle,
            style: AppTypography.displayLg.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            context.l10n.forgotPasswordSuccessBody,
            style: AppTypography.bodySm.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

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

class _Input extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  const _Input({
    required this.controller,
    required this.hintText,
    required this.onChanged,
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
        keyboardType: keyboardType,
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
              style:
                  TextStyle(color: colors.error, fontSize: AppTypography.sizeMd),
            ),
          ),
        ],
      ),
    );
  }
}
