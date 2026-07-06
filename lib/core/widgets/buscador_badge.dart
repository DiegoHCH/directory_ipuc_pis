import 'package:flutter/material.dart';
import '../extensions/l10n_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Insignia para miembros que solo buscan/contratan (sin categoría de
/// servicio). Reemplaza el punto+categoría en las pantallas de perfil.
class BuscadorBadge extends StatelessWidget {
  const BuscadorBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3, vertical: 5),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: AppRadius.chip,
        border: Border.all(color: colors.textSecondary.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 13, color: colors.textSecondary),
          const SizedBox(width: 5),
          Text(
            context.l10n.profileBuscadorBadge,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: AppTypography.sizeSm,
              fontWeight: AppTypography.semibold,
              letterSpacing: AppTypography.trackingNormal,
            ),
          ),
        ],
      ),
    );
  }
}
