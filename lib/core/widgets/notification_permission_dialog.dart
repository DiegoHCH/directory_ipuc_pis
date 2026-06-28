import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../extensions/l10n_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

const _prefKey = 'notification_permission_asked';

Future<void> maybeAskNotificationPermission(
  BuildContext context, {
  VoidCallback? onAccepted,
  VoidCallback? onDeclined,
}) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(_prefKey) == true) return;
  await prefs.setBool(_prefKey, true);
  if (!context.mounted) return;
  await showModalBottomSheet<void>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    builder: (_) => _NotificationSheet(
      onAccepted: onAccepted,
      onDeclined: onDeclined,
    ),
  );
}

class _NotificationSheet extends StatelessWidget {
  final VoidCallback? onAccepted;
  final VoidCallback? onDeclined;
  const _NotificationSheet({this.onAccepted, this.onDeclined});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.x6,
        AppSpacing.x6,
        AppSpacing.x6,
        AppSpacing.x6 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.x6),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: colors.primaryMuted,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: colors.primary,
              size: 36,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          Text(
            context.l10n.notifDialogTitle,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: AppTypography.size2xl,
              fontWeight: AppTypography.extrabold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            context.l10n.notifDialogBody,
            style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x7),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onAccepted?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.textOnPrimary,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
                elevation: 0,
              ),
              child: Text(
                context.l10n.btnActivateNotifications,
                style: const TextStyle(
                    fontSize: AppTypography.sizeLg,
                    fontWeight: AppTypography.semibold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDeclined?.call();
            },
            child: Text(
              context.l10n.btnNotNow,
              style: AppTypography.bodyMd.copyWith(
                color: colors.textSecondary,
                fontWeight: AppTypography.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
