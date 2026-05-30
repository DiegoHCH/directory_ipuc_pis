import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../viewmodel/register_viewmodel.dart';
import 'widgets/category_selector.dart';
import 'widgets/offers_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final RegisterViewModel _viewModel;
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _viewModel = RegisterViewModel();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) => _RegisterBody(
          viewModel: _viewModel,
          nameController: _nameController,
          bioController: _bioController,
          phoneController: _phoneController,
        ),
      ),
    );
  }
}

class _RegisterBody extends StatelessWidget {
  final RegisterViewModel viewModel;
  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController phoneController;

  const _RegisterBody({
    required this.viewModel,
    required this.nameController,
    required this.bioController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _TopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nuevo',
                    style: TextStyle(
                      color: context.colors.textPrimary,
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
                        color: context.colors.textSecondary,
                        fontSize: 13,
                        height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const _PhotoUploader(),
                  const SizedBox(height: 24),
                  _FieldLabel('TU NOMBRE'),
                  const SizedBox(height: 8),
                  _FormField(
                    controller: nameController,
                    hintText: 'Nombre completo',
                    onChanged: viewModel.setName,
                  ),
                  const SizedBox(height: 20),
                  _FieldLabel('¿EN QUÉ CATEGORÍA ENCAJAS?'),
                  const SizedBox(height: 10),
                  CategorySelector(
                    selected: viewModel.category,
                    onSelected: viewModel.setCategory,
                  ),
                  const SizedBox(height: 20),
                  _FieldLabel('DESCRIBE LO QUE OFRECES'),
                  const SizedBox(height: 8),
                  _FormField(
                    controller: bioController,
                    hintText: 'Cuéntale a la comunidad qué haces...',
                    maxLines: 4,
                    onChanged: viewModel.setBio,
                  ),
                  const SizedBox(height: 20),
                  _FieldLabel('TUS SERVICIOS'),
                  const SizedBox(height: 10),
                  OffersInput(
                    offers: viewModel.offers,
                    onAdd: viewModel.addOffer,
                    onRemove: viewModel.removeOffer,
                  ),
                  const SizedBox(height: 20),
                  _FieldLabel('TU NÚMERO DE WHATSAPP'),
                  const SizedBox(height: 8),
                  _PhoneField(
                    controller: phoneController,
                    onChanged: viewModel.setPhone,
                  ),
                  const SizedBox(height: 28),
                  _SubmitButton(viewModel: viewModel),
                ],
              ),
            ),
          ),
        ],
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
              onTap: () => Navigator.of(context).maybePop(),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: kAccentBlue.withValues(alpha: 0.4)),
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

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final ValueChanged<String> onChanged;

  const _FormField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.maxLines = 1,
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
        maxLines: maxLines,
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                fontWeight: FontWeight.w500,
              ),
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
  final RegisterViewModel viewModel;

  const _SubmitButton({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: viewModel.isValid && !viewModel.isSubmitting
            ? () => viewModel.submit()
            : null,
        icon: viewModel.isSubmitting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.chat, size: 20),
        label: const Text(
          'Crear y enviar invitación',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccentBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              context.colors.surface,
          disabledForegroundColor: context.colors.textSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
