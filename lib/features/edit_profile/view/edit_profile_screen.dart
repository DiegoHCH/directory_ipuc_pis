import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../directory/model/member.dart';
import '../../register/view/widgets/category_selector.dart';
import '../../register/view/widgets/offers_input.dart';
import '../viewmodel/edit_profile_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  final Member member;

  const EditProfileScreen({super.key, required this.member});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final EditProfileViewModel _viewModel;
  late final TextEditingController _nameController;
  late final TextEditingController _businessController;

  @override
  void initState() {
    super.initState();
    _viewModel = EditProfileViewModel(widget.member);
    _nameController = TextEditingController(text: widget.member.name);
    _businessController =
        TextEditingController(text: widget.member.description);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _nameController.dispose();
    _businessController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    await _viewModel.save();
    if (mounted) Navigator.of(context).pop();
  }

  void _onDelete() {
    final colors = context.colors;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '¿Eliminar perfil?',
          style: TextStyle(color: colors.textPrimary),
        ),
        content: Text(
          'Esta acción no se puede deshacer. Tu perfil desaparecerá del directorio.',
          style: TextStyle(color: colors.textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancelar',
                style: TextStyle(color: colors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // TODO: eliminar perfil
            },
            child: const Text('Eliminar',
                style: TextStyle(color: Color(0xFFEF5350))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) => _EditBody(
          viewModel: _viewModel,
          nameController: _nameController,
          businessController: _businessController,
          onSave: _onSave,
          onDelete: _onDelete,
        ),
      ),
    );
  }
}

class _EditBody extends StatelessWidget {
  final EditProfileViewModel viewModel;
  final TextEditingController nameController;
  final TextEditingController businessController;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  const _EditBody({
    required this.viewModel,
    required this.nameController,
    required this.businessController,
    required this.onSave,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _TopBar(viewModel: viewModel, onSave: onSave),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: _AvatarPicker(
                        initials: viewModel.original.initials),
                  ),
                  const SizedBox(height: 24),
                  _FieldLabel('TU NOMBRE'),
                  const SizedBox(height: 8),
                  _InputField(
                    controller: nameController,
                    onChanged: viewModel.setName,
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel('NEGOCIO O SERVICIO'),
                  const SizedBox(height: 8),
                  _InputField(
                    controller: businessController,
                    onChanged: viewModel.setBusinessName,
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel('CATEGORÍA'),
                  const SizedBox(height: 10),
                  CategorySelector(
                    selected: viewModel.category,
                    onSelected: viewModel.setCategory,
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel('TUS SERVICIOS'),
                  const SizedBox(height: 10),
                  OffersInput(
                    offers: viewModel.offers,
                    onAdd: viewModel.addOffer,
                    onRemove: viewModel.removeOffer,
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel('TELÉFONO · VERIFICADO'),
                  const SizedBox(height: 8),
                  _PhoneVerifiedField(phone: viewModel.original.phone),
                  const SizedBox(height: 16),
                  _VisibilityToggle(
                    visible: viewModel.visible,
                    onToggle: viewModel.toggleVisibility,
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: GestureDetector(
                      onTap: onDelete,
                      child: const Text(
                        'Eliminar mi perfil',
                        style: TextStyle(
                          color: Color(0xFFEF5350),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
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
  final EditProfileViewModel viewModel;
  final VoidCallback onSave;

  const _TopBar({required this.viewModel, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Text(
                'Cancelar',
                style:
                    TextStyle(color: colors.textSecondary, fontSize: 15),
              ),
            ),
          ),
          Text(
            'Editar perfil',
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: viewModel.isSaving ? null : onSave,
              child: viewModel.isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: kAccentBlue),
                    )
                  : Text(
                      'Guardar',
                      style: TextStyle(
                        color: viewModel.isDirty
                            ? kAccentBlue
                            : colors.textSecondary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  final String initials;

  const _AvatarPicker({required this.initials});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: colors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: kAccentBlue, width: 2.5),
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: kAccentBlue,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: kAccentBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.background, width: 2),
                ),
                child: const Icon(Icons.camera_alt,
                    color: Colors.white, size: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'CAMBIAR FOTO',
          style: TextStyle(
            color: kAccentBlue,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
      ],
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
  final ValueChanged<String> onChanged;

  const _InputField({required this.controller, required this.onChanged});

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
        style: TextStyle(color: colors.textPrimary, fontSize: 15),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              phone,
              style:
                  TextStyle(color: colors.textSecondary, fontSize: 15),
            ),
          ),
          const Row(
            children: [
              Icon(Icons.check, color: Color(0xFF4CAF50), size: 14),
              SizedBox(width: 4),
              Text(
                'VERIFICADO',
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Visible en el directorio',
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Apágalo si no quieres recibir contactos por ahora.',
                  style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 12,
                      height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: visible,
            onChanged: (_) => onToggle(),
            activeThumbColor: Colors.white,
            activeTrackColor: kAccentBlue,
          ),
        ],
      ),
    );
  }
}
