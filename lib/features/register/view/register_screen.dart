import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../provider/register_provider.dart';
import 'widgets/category_selector.dart';
import 'widgets/offers_input.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nuevo',
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          const Text(
                            'hermano.',
                            style: TextStyle(
                              color: kAccentBlue,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Le enviarás un link por WhatsApp para que confirme y pueda editar su perfil.',
                            style: TextStyle(
                                color: colors.textSecondary,
                                fontSize: 13,
                                height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ZoomIn(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 500),
                      child: const _PhotoUploader(),
                    ),
                    const SizedBox(height: 24),
                    FadeInLeft(
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 400),
                      child: _FieldLabel('TU NOMBRE'),
                    ),
                    const SizedBox(height: 8),
                    _InputField(
                      controller: _nameController,
                      hintText: 'Nombre completo',
                      onChanged: notifier.setName,
                    ),
                    const SizedBox(height: 20),
                    _FieldLabel('¿EN QUÉ CATEGORÍA ENCAJAS?'),
                    const SizedBox(height: 10),
                    CategorySelector(
                      selected: state.category,
                      onSelected: notifier.setCategory,
                    ),
                    const SizedBox(height: 20),
                    _FieldLabel('DESCRIBE LO QUE OFRECES'),
                    const SizedBox(height: 8),
                    _InputField(
                      controller: _bioController,
                      hintText: 'Cuéntale a la comunidad qué haces...',
                      maxLines: 4,
                      onChanged: notifier.setBio,
                    ),
                    const SizedBox(height: 20),
                    _FieldLabel('TUS SERVICIOS'),
                    const SizedBox(height: 10),
                    OffersInput(
                      offers: state.offers,
                      onAdd: notifier.addOffer,
                      onRemove: notifier.removeOffer,
                    ),
                    const SizedBox(height: 20),
                    _FieldLabel('TU NÚMERO DE WHATSAPP'),
                    const SizedBox(height: 8),
                    _PhoneField(
                      controller: _phoneController,
                      onChanged: notifier.setPhone,
                    ),
                    const SizedBox(height: 20),
                    _FieldLabel('TU CORREO'),
                    const SizedBox(height: 8),
                    _InputField(
                      controller: _emailController,
                      hintText: 'correo@ejemplo.com',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: notifier.setEmail,
                    ),
                    const SizedBox(height: 20),
                    _FieldLabel('CONTRASEÑA'),
                    const SizedBox(height: 8),
                    _InputField(
                      controller: _passwordController,
                      hintText: 'Mínimo 6 caracteres',
                      obscureText: true,
                      onChanged: notifier.setPassword,
                    ),
                    if (state.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      _ErrorBanner(message: state.errorMessage!),
                    ],
                    const SizedBox(height: 28),
                    _SubmitButton(
                      isValid: state.isValid,
                      isSubmitting: state.isSubmitting,
                      onSubmit: () async {
                        final ok = await notifier.submit();
                        if (ok && context.mounted) {
                          context.go('/');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  '¡Tu perfil fue creado! Ya apareces en el directorio.'),
                              backgroundColor: Color(0xFF4CAF50),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kAccentBlue.withValues(alpha: 0.4)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, color: kAccentBlue, size: 13),
                SizedBox(width: 5),
                Text(
                  'ADMIN',
                  style: TextStyle(
                    color: kAccentBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoUploader extends StatelessWidget {
  const _PhotoUploader();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: context.colors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                  color: kAccentBlue.withValues(alpha: 0.4), width: 1.5),
            ),
            child: const Icon(Icons.camera_alt_outlined,
                color: kAccentBlue, size: 28),
          ),
          const SizedBox(height: 8),
          const Text(
            'SUBIR FOTO',
            style: TextStyle(
              color: kAccentBlue,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
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
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        maxLines: obscureText ? 1 : maxLines,
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(color: colors.textPrimary, fontSize: 15),
              decoration: InputDecoration(
                hintText: '311 412 8033',
                hintStyle:
                    TextStyle(color: colors.textSecondary, fontSize: 15),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
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
      height: 52,
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
        label: const Text(
          'Crear mi perfil',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccentBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: colors.surface,
          disabledForegroundColor: colors.textSecondary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
    );
  }
}
