import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/member_avatar.dart';
import '../../../features/settings/provider/settings_provider.dart';
import '../../directory/model/member.dart';
import '../provider/current_member_provider.dart';
import '../provider/my_profile_provider.dart';
import '../provider/profile_stats_provider.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/utils/l10n_errors.dart';
import '../../edit_profile/provider/edit_profile_provider.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberAsync = ref.watch(currentMemberProvider);
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: memberAsync.when(
          loading: () => Center(
              child: CircularProgressIndicator(color: colors.primary)),
          error: (e, _) => _MessageView(
            icon: Icons.error_outline,
            message: context.l10n.errLoadProfile,
          ),
          data: (member) => member == null
              ? const _NotLoggedIn()
              : _ProfileContent(member: member),
        ),
      ),
    );
  }
}

void _confirmDelete(BuildContext context, WidgetRef ref, Member member) {
  final colors = context.colors;
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog),
      title: Text(context.l10n.deleteDialogTitle,
          style: TextStyle(color: colors.textPrimary)),
      content: Text(
        context.l10n.deleteDialogBody,
        style: TextStyle(
            color: colors.textSecondary,
            height: AppTypography.lineHeightNormal),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(context.l10n.btnCancel,
              style: TextStyle(color: colors.textSecondary)),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(ctx).pop();
            final notifier = ref.read(editProfileProvider(member).notifier);
            final errorKey = await notifier.delete();
            if (!context.mounted) return;
            if (errorKey != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizeError(context.l10n, errorKey)),
                  backgroundColor: colors.error,
                ),
              );
              return;
            }
            // Navegar antes de borrar Auth para evitar que authStateChanges
            // invalide el context antes de la navegación.
            context.go('/directory');
            notifier.deleteAuthAccount();
          },
          child: Text(context.l10n.btnDelete,
              style: TextStyle(color: colors.error)),
        ),
      ],
    ),
  );
}

class _ProfileContent extends ConsumerWidget {
  final Member member;

  const _ProfileContent({required this.member});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(myProfileProvider);
    final statsAsync = ref.watch(profileStatsProvider(member.id));
    final contactsEnabled =
        ref.watch(settingsProvider).valueOrNull?.notifyContacts ?? true;
    final colors = context.colors;

    final stats = statsAsync.valueOrNull ??
        ProfileStats(
          weeklyViews: 0,
          whatsappContacts: 0,
          activeServices: member.offers.length,
        );

    return Column(
      children: [
        FadeInDown(
          duration: const Duration(milliseconds: 400),
          child: _TopBar(status: profileState.status),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.x5),
                ZoomIn(
                  duration: const Duration(milliseconds: 500),
                  child: Center(
                    child: MemberAvatar(
                        member: member,
                        size: AppSpacing.avatarLg,
                        circle: true),
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 400),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          context.l10n.profileMyProfile,
                          style: TextStyle(
                            color: colors.primary,
                            fontSize: AppTypography.sizeXs,
                            fontWeight: AppTypography.semibold,
                            letterSpacing: AppTypography.trackingWider,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: Text(
                          member.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headingMd.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Center(
                        child: Text(
                          member.description,
                          style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: AppTypography.sizeBase),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.x6),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 400),
                  child: _StatsRow(
                    stats: stats.copyWith(
                      activeServices: member.offers.length,
                    ),
                    isLoading: statsAsync.isLoading,
                    contactsEnabled: contactsEnabled,
                  ),
                ),
                const SizedBox(height: AppSpacing.x6),
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 400),
                  child: _OffersSection(member: member),
                ),
                const SizedBox(height: AppSpacing.x6),
              ],
            ),
          ),
        ),
        FadeInUp(
          delay: const Duration(milliseconds: 350),
          duration: const Duration(milliseconds: 400),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.x6, AppSpacing.x3, AppSpacing.x6, AppSpacing.x4),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: AppSpacing.buttonHeight,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        context.push('/edit-profile', extra: member),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(
                      context.l10n.btnEditProfile,
                      style: const TextStyle(
                          fontSize: AppTypography.sizeLg,
                          fontWeight: AppTypography.semibold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.textOnPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.button),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                GestureDetector(
                  onTap: () => _confirmDelete(context, ref, member),
                  child: Text(
                    context.l10n.btnDeleteProfile,
                    style: TextStyle(
                      color: colors.error,
                      fontSize: AppTypography.sizeBase,
                      fontWeight: AppTypography.medium,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NotLoggedIn extends StatelessWidget {
  const _NotLoggedIn();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline, size: 48, color: colors.textSecondary),
            const SizedBox(height: AppSpacing.x4),
            Text(
              context.l10n.authSignInToView,
              style: AppTypography.titleLg.copyWith(
                color: colors.textPrimary,
                fontWeight: AppTypography.semibold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.x5),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => context.go('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.textOnPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.button),
                  elevation: 0,
                ),
                child: Text(context.l10n.btnSignIn,
                    style: const TextStyle(
                        fontSize: AppTypography.sizeLg,
                        fontWeight: AppTypography.semibold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  final IconData icon;
  final String message;

  const _MessageView({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: colors.textSecondary),
          const SizedBox(height: AppSpacing.x4),
          Text(message,
              style: AppTypography.titleLg.copyWith(color: colors.textPrimary)),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final ProfileStatus status;

  const _TopBar({required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4, vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () =>
                  context.canPop() ? context.pop() : context.go('/directory'),
              child: Container(
                width: AppSpacing.iconButtonSize,
                height: AppSpacing.iconButtonSize,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: AppRadius.iconButton,
                ),
                child: Icon(Icons.chevron_left,
                    color: colors.textPrimary, size: 22),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x3, vertical: 6),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: AppRadius.chip,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: colors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  status.label,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: AppTypography.sizeXs,
                    fontWeight: AppTypography.semibold,
                    letterSpacing: AppTypography.trackingNormal,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: AppSpacing.iconButtonSize,
              height: AppSpacing.iconButtonSize,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: AppRadius.iconButton,
              ),
              child: Icon(Icons.ios_share,
                  color: colors.textPrimary, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final ProfileStats stats;
  final bool isLoading;
  final bool contactsEnabled;

  const _StatsRow({
    required this.stats,
    this.isLoading = false,
    this.contactsEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final loading = isLoading ? '—' : null;
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.button,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _StatCell(
              value: contactsEnabled
                  ? (loading ?? '${stats.weeklyViews}')
                  : '—',
              label: context.l10n.profileViews,
              muted: !contactsEnabled,
            ),
            _Divider(),
            _StatCell(
              value: contactsEnabled
                  ? (loading ?? '${stats.whatsappContacts}')
                  : '—',
              label: context.l10n.profileContacts,
              muted: !contactsEnabled,
            ),
            _Divider(),
            _StatCell(
              value: '${stats.activeServices}',
              label: context.l10n.profileActiveServices,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  final bool muted;

  const _StatCell({
    required this.value,
    required this.label,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.x4, horizontal: AppSpacing.x2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: AppTypography.headingMd.copyWith(
                color: muted ? colors.textSecondary : colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: AppTypography.sizeXs,
                  height: AppTypography.lineHeightSnug),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VerticalDivider(
      color: context.colors.textSecondary.withValues(alpha: 0.15),
      width: 1,
      indent: AppSpacing.x3,
      endIndent: AppSpacing.x3,
    );
  }
}

class _OffersSection extends StatelessWidget {
  final Member member;

  const _OffersSection({required this.member});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.profileWhatYouOffer,
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: AppTypography.sizeXs,
                fontWeight: AppTypography.bold,
                letterSpacing: AppTypography.trackingWider,
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/edit-profile', extra: member),
              child: Text(
                context.l10n.btnEdit,
                style: TextStyle(
                  color: colors.primary,
                  fontSize: AppTypography.sizeXs,
                  fontWeight: AppTypography.bold,
                  letterSpacing: AppTypography.trackingWide,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        if (member.offers.isEmpty)
          Text(context.l10n.regNoServices,
              style: TextStyle(
                  color: colors.textSecondary, fontSize: AppTypography.sizeMd))
        else
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: member.offers
                .map(
                  (o) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: AppSpacing.x2),
                    decoration: BoxDecoration(
                      borderRadius: AppRadius.chip,
                      border: Border.all(
                          color: colors.primary.withValues(alpha: 0.4)),
                    ),
                    child: Text(o,
                        style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: AppTypography.sizeMd)),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
