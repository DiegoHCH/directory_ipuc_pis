import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../viewmodel/verification_viewmodel.dart';
import 'widgets/otp_input.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late final VerificationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = VerificationViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) => _VerificationBody(viewModel: _viewModel),
      ),
    );
  }
}

class _VerificationBody extends StatelessWidget {
  final VerificationViewModel viewModel;

  const _VerificationBody({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TopBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _PhoneIcon(),
                  const SizedBox(height: 20),
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
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  OtpInput(
                    length: 6,
                    digits: viewModel.digits,
                    onChanged: (record) =>
                        viewModel.setDigit(record.$1, record.$2),
                  ),
                  const SizedBox(height: 16),
                  _ResendRow(viewModel: viewModel),
                  const SizedBox(height: 24),
                  const _InfoCard(),
                ],
              ),
            ),
          ),
          _SubmitButton(viewModel: viewModel),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: GestureDetector(
        onTap: () => Navigator.of(context).maybePop(),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.chevron_left,
              color: context.colors.textPrimary, size: 22),
        ),
      ),
    );
  }
}

class _PhoneIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.phone, color: kAccentBlue, size: 22),
    );
  }
}

class _ResendRow extends StatelessWidget {
  final VerificationViewModel viewModel;

  const _ResendRow({required this.viewModel});

  String _formatCountdown(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(1, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Text(
          '¿No te llegó? ',
          style: TextStyle(color: colors.textSecondary, fontSize: 13),
        ),
        GestureDetector(
          onTap: viewModel.canResend ? viewModel.resend : null,
          child: Text(
            viewModel.canResend
                ? 'Reenviar'
                : 'Reenviar en ${_formatCountdown(viewModel.countdown)}',
            style: TextStyle(
              color: viewModel.canResend ? kAccentBlue : colors.textSecondary,
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
  const _InfoCard();

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
          Icon(
            Icons.verified_user_outlined,
            color: kAccentBlue.withValues(alpha: 0.7),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'Tu número queda '),
                  TextSpan(
                    text: 'atado a tu perfil',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
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

class _SubmitButton extends StatelessWidget {
  final VerificationViewModel viewModel;

  const _SubmitButton({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: viewModel.isComplete && !viewModel.isVerifying
              ? () => viewModel.verify()
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: kAccentBlue,
            foregroundColor: Colors.white,
            disabledBackgroundColor: colors.surface,
            disabledForegroundColor: colors.textSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: viewModel.isVerifying
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
    );
  }
}
