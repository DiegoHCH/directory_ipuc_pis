import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/cloudinary_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../directory/model/member.dart';
import '../../register/view/widgets/category_selector.dart';
import '../../register/view/widgets/offers_input.dart';
import '../provider/edit_profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final Member member;

  const EditProfileScreen({super.key, required this.member});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _businessController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member.name);
    _businessController =
        TextEditingController(text: widget.member.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _businessController.dispose();
    super.dispose();
  }

  void _onDelete() {
    final colors = context.colors;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('¿Eliminar perfil?',
            style: TextStyle(color: colors.textPrimary)),
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
            onPressed: () async {
              Navigator.of(ctx).pop();
              final ok = await ref
                  .read(editProfileProvider(widget.member).notifier)
                  .delete();
              if (!mounted) return;
              if (ok) {
                context.go('/');
              } else {
                final msg = ref
                        .read(editProfileProvider(widget.member))
                        .errorMessage ??
                    'No se pudo eliminar.';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg),
                    backgroundColor: const Color(0xFFEF5350),
                  ),
                );
              }
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
    final state = ref.watch(editProfileProvider(widget.member));
    final notifier = ref.read(editProfileProvider(widget.member).notifier);
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: Text('Cancelar',
                          style: TextStyle(
                              color: colors.textSecondary, fontSize: 15)),
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
                      behavior: HitTestBehavior.opaque,
                      onTap: state.isSaving || !state.isDirty
                          ? null
                          : () async {
                              final screenContext = context;
                              final ok = await notifier.save();
                              if (!screenContext.mounted) return;
                              if (ok) {
                                screenContext.pop();
                                ScaffoldMessenger.of(screenContext).showSnackBar(
                                  const SnackBar(
                                    content: Text('Cambios guardados.'),
                                    backgroundColor: Color(0xFF4CAF50),
                                  ),
                                );
                              } else {
                                final msg = ref
                                        .read(editProfileProvider(
                                            widget.member))
                                        .errorMessage ??
                                    'No se pudo guardar.';
                                ScaffoldMessenger.of(screenContext).showSnackBar(
                                  SnackBar(
                                    content: Text(msg),
                                    backgroundColor: const Color(0xFFEF5350),
                                  ),
                                );
                              }
                            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: state.isSaving
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: kAccentBlue),
                              )
                            : Text(
                                'Guardar',
                                style: TextStyle(
                                  color: state.isDirty
                                      ? kAccentBlue
                                      : colors.textSecondary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(child: _AvatarPicker(member: widget.member)),
                    const SizedBox(height: 24),
                    _FieldLabel('TU NOMBRE'),
                    const SizedBox(height: 8),
                    _InputField(
                      controller: _nameController,
                      onChanged: notifier.setName,
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel('NEGOCIO O SERVICIO'),
                    const SizedBox(height: 8),
                    _InputField(
                      controller: _businessController,
                      onChanged: notifier.setBusinessName,
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel('CATEGORÍA'),
                    const SizedBox(height: 10),
                    CategorySelector(
                      selected: state.category,
                      onSelected: notifier.setCategory,
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel('TUS SERVICIOS'),
                    const SizedBox(height: 10),
                    OffersInput(
                      offers: state.offers,
                      onAdd: notifier.addOffer,
                      onRemove: notifier.removeOffer,
                    ),
                    const SizedBox(height: 16),
                    _FieldLabel('TELÉFONO · VERIFICADO'),
                    const SizedBox(height: 8),
                    _PhoneVerifiedField(phone: widget.member.phone),
                    const SizedBox(height: 16),
                    _VisibilityToggle(
                      visible: state.visible,
                      onToggle: notifier.toggleVisibility,
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child: GestureDetector(
                        onTap: _onDelete,
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
                  border: Border.all(color: kAccentBlue, width: 2.5),
                ),
                child: ClipOval(
                  child: state.isUploadingPhoto
                      ? const Center(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5, color: kAccentBlue),
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
                                  style: const TextStyle(
                                    color: kAccentBlue,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                member.initials,
                                style: const TextStyle(
                                  color: kAccentBlue,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
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
          Text(
            state.isUploadingPhoto ? 'SUBIENDO...' : 'CAMBIAR FOTO',
            style: TextStyle(
              color: state.isUploadingPhoto
                  ? colors.textSecondary
                  : kAccentBlue,
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
            child: Text(phone,
                style:
                    TextStyle(color: colors.textSecondary, fontSize: 15)),
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
