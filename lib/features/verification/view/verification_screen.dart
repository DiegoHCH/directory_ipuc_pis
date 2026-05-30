import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../provider/verification_provider.dart';
import 'widgets/otp_input.dart';

class VerificationScreen extends ConsumerWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(verificationProvider);
    final notifier = ref.read(verificationProvider.notifier);
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.chevron_left,
                        color: colors.textPrimary, size: 22),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    BounceInDown(
                      duration: const Duration(milliseconds: 700),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.phone,
                            color: kAccentBlue, size: 22),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInDown(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 450),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verifica que',
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          const Text(
                            'eres tú.',
                            style: TextStyle(
                              color: kAccentBlue,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tu pastor te envió un link para reclamar tu perfil. Ingresa el código de 6 dígitos para activar la edición.',
                            style: TextStyle(
                                color: colors.textSecondary,
                                fontSize: 13,
                                height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    FadeInUp(
                      delay: const Duration(milliseconds: 350),
                      duration: const Duration(milliseconds: 450),
                      child: OtpInput(
                        digits: state.digits,
                        onDigitChanged: notifier.setDigit,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeIn(
                      delay: const Duration(milliseconds: 500),
                      duration: const Duration(milliseconds: 400),
                      child: _ResendRow(state: state, onResend: notifier.resend),
                    ),
                    const SizedBox(height: 24),
                    FadeInUp(
                      delay: const Duration(milliseconds: 550),
                      duration: const Duration(milliseconds: 400),
                      child: _InfoCard(),
                    ),
                  ],
                ),
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: state.isComplete && !state.isVerifying
                        ? () => notifier.verify()
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentBlue,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: colors.surface,
                      disabledForegroundColor: colors.textSecondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: state.isVerifying
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Continuar al registro',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResendRow extends StatelessWidget {
  final VerificationState state;
  final VoidCallback onResend;

  const _ResendRow({required this.state, required this.onResend});

  String _fmt(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '$m:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Text('¿No te llegó? ',
            style: TextStyle(color: colors.textSecondary, fontSize: 13)),
        GestureDetector(
          onTap: state.canResend ? onResend : null,
          child: Text(
            state.canResend
                ? 'Reenviar'
                : 'Reenviar en ${_fmt(state.countdown)}',
            style: TextStyle(
              color: state.canResend ? kAccentBlue : colors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_user_outlined,
              color: kAccentBlue.withValues(alpha: 0.7), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                    color: colors.textSecondary, fontSize: 13, height: 1.5),
                children: [
                  const TextSpan(text: 'Tu número queda '),
                  TextSpan(
                    text: 'atado a tu perfil',
                    style: TextStyle(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600),
                  ),
                  const TextSpan(
                    text:
                        ' — nadie más podrá registrarse con él. Un líder de la iglesia revisará tu perfil antes de publicarlo.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
