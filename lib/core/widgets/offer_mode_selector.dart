import 'package:flutter/material.dart';
import '../extensions/l10n_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Selector de "¿Qué quieres hacer?" — ofrecer un servicio vs. solo buscar
/// y contactar. Usado tanto en registro como en edición de perfil.
class OfferModeSelector extends StatelessWidget {
  final bool offersServices;
  final ValueChanged<bool> onSelected;

  const OfferModeSelector({
    super.key,
    required this.offersServices,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _OfferModeCard(
          icon: Icons.storefront_outlined,
          title: context.l10n.regOfferService,
          subtitle: context.l10n.regOfferServiceDesc,
          selected: offersServices,
          onTap: () => onSelected(true),
        ),
        const SizedBox(height: AppSpacing.x2),
        _OfferModeCard(
          icon: Icons.search,
          title: context.l10n.regSearchOnly,
          subtitle: context.l10n.regSearchOnlyDesc,
          selected: !offersServices,
          onTap: () => onSelected(false),
        ),
      ],
    );
  }
}

class _OfferModeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _OfferModeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(AppSpacing.x4),
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.surface,
          borderRadius: AppRadius.input,
          border: selected
              ? null
              : Border.all(color: colors.textSecondary.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 22,
                color: selected ? Colors.white : colors.textSecondary),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: selected ? Colors.white : colors.textPrimary,
                      fontWeight: AppTypography.semibold,
                      fontSize: AppTypography.sizeBase,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: selected
                          ? Colors.white.withValues(alpha: 0.85)
                          : colors.textSecondary,
                      fontSize: AppTypography.sizeXs,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
