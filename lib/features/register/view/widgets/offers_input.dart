import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class OffersInput extends StatelessWidget {
  final List<String> offers;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  const OffersInput({
    super.key,
    required this.offers,
    required this.onAdd,
    required this.onRemove,
  });

  void _showAddDialog(BuildContext context) {
    final colors = context.colors;
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
        title: Text(
          'Agregar servicio',
          style: AppTypography.titleLg.copyWith(color: colors.textPrimary),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: TextStyle(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Ej: Tortas de cumpleaños',
            hintStyle: TextStyle(color: colors.textSecondary),
            filled: true,
            fillColor: colors.background,
            border: OutlineInputBorder(
              borderRadius: AppRadius.iconButton,
              borderSide: BorderSide.none,
            ),
          ),
          onSubmitted: (v) {
            onAdd(v);
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar',
                style: TextStyle(color: colors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              onAdd(controller.text);
              Navigator.of(context).pop();
            },
            child: Text('Agregar',
                style: TextStyle(color: colors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      spacing: AppSpacing.x2,
      runSpacing: AppSpacing.x2,
      children: [
        ...offers.map(
          (offer) => _OfferChip(
            label: offer,
            onRemove: () => onRemove(offer),
          ),
        ),
        GestureDetector(
          onTap: () => _showAddDialog(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3, vertical: 7),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: AppRadius.chip,
              border: Border.all(
                  color: colors.textSecondary.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: colors.textSecondary, size: 14),
                const SizedBox(width: AppSpacing.x1),
                Text(
                  'Agregar',
                  style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: AppTypography.sizeMd),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OfferChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _OfferChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.only(left: AppSpacing.x3, right: 6, top: 7, bottom: 7),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.chip,
        border: Border.all(color: colors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
                color: colors.textPrimary, fontSize: AppTypography.sizeMd),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, color: colors.textSecondary, size: 14),
          ),
        ],
      ),
    );
  }
}
