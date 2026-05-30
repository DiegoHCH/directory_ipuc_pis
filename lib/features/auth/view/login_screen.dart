import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../provider/login_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () =>
                    context.canPop() ? context.pop() : context.go('/'),
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
              const SizedBox(height: 24),
              FadeInDown(
                duration: const Duration(milliseconds: 450),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenido de',
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const Text(
                      'vuelta.',
                      style: TextStyle(
                        color: kAccentBlue,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Inicia sesión para editar tu perfil.',
                      style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 13,
                          height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _Label('TU CORREO'),
              const SizedBox(height: 8),
              _Input(
                controller: _emailController,
                hintText: 'correo@ejemplo.com',
                keyboardType: TextInputType.emailAddress,
                onChanged: notifier.setEmail,
              ),
              const SizedBox(height: 20),
              _Label('CONTRASEÑA'),
              const SizedBox(height: 8),
              _Input(
                controller: _passwordController,
                hintText: 'Tu contraseña',
                obscureText: true,
                onChanged: notifier.setPassword,
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 16),
                _ErrorBanner(message: state.errorMessage!),
              ],
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: state.isValid && !state.isSubmitting
                      ? () async {
                          final ok = await notifier.submit();
                          if (ok && context.mounted) context.go('/my-profile');
                        }
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
                  child: state.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Iniciar sesión',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => context.go('/register'),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(
                          color: colors.textSecondary, fontSize: 14),
                      children: const [
                        TextSpan(text: '¿No tienes perfil? '),
                        TextSpan(
                          text: 'Regístrate',
                          style: TextStyle(
                              color: kAccentBlue,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String> onChanged;

  const _Input({
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText,
        keyboardType: keyboardType,
        autocorrect: !obscureText,
        enableSuggestions: !obscureText,
        style: TextStyle(color: colors.textPrimary, fontSize: 15),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: colors.textSecondary, fontSize: 15),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEF5350).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFEF5350), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFFEF5350), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
