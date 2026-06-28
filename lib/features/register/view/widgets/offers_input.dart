import 'package:flutter/material.dart';
import '../../../../core/extensions/l10n_extension.dart';
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
    final controller = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final colors = ctx.colors;
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.x6,
              AppSpacing.x6,
              AppSpacing.x6,
              AppSpacing.x6 + MediaQuery.of(ctx).padding.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: colors.textSecondary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.x5),
                Text(
                  ctx.l10n.btnAddService,
                  style: AppTypography.titleLg
                      .copyWith(color: colors.textPrimary,
                          fontWeight: AppTypography.bold),
                ),
                const SizedBox(height: AppSpacing.x3),
                TextField(
                  controller: controller,
                  autofocus: true,
                  style: TextStyle(color: colors.textPrimary),
                  decoration: InputDecoration(
                    hintText: ctx.l10n.regServiceHint,
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
                    Navigator.of(ctx).pop();
                  },
                ),
                const SizedBox(height: AppSpacing.x4),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.textSecondary,
                          side: BorderSide(
                              color: colors.textSecondary.withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.button),
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: Text(ctx.l10n.btnCancel),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          onAdd(controller.text);
                          Navigator.of(ctx).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.textOnPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.button),
                          elevation: 0,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: Text(ctx.l10n.btnAdd),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
                  context.l10n.btnAdd,
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
