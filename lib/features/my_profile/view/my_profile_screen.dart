import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
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
import '../../auth/repository/auth_repository.dart';
import '../../directory/repository/member_repository.dart';
import '../../../core/widgets/lottie_loader_screen.dart';

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
  final passwordController = TextEditingController();

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
              Center(
                child: Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: colors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.delete_outline, color: colors.error, size: 30),
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                context.l10n.deleteDialogTitle,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: AppTypography.size2xl,
                  fontWeight: AppTypography.extrabold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.deleteDialogBody,
                style: TextStyle(
                    color: colors.textSecondary,
                    height: AppTypography.lineHeightNormal),
              ),
              const SizedBox(height: AppSpacing.x4),
              TextField(
                controller: passwordController,
                obscureText: true,
                autofocus: true,
                style: TextStyle(color: colors.textPrimary),
                decoration: InputDecoration(
                  labelText: context.l10n.authPasswordLabel,
                  labelStyle: TextStyle(color: colors.textSecondary),
                  filled: true,
                  fillColor: colors.background,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.iconButton,
                    borderSide: BorderSide.none,
                  ),
                ),
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
                      child: Text(context.l10n.btnCancel),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final password = passwordController.text.trim();
                        Navigator.of(ctx).pop();
                        if (password.isEmpty) return;

                        final authRepo   = ref.read(authRepositoryProvider);
                        final memberRepo = ref.read(memberRepositoryProvider);
                        final router     = GoRouter.of(context);
                        final messenger  = ScaffoldMessenger.of(context);
                        final l10n       = context.l10n;
                        final errorColor = colors.error;
                        final memberId   = member.id;

                        final errorKey = await authRepo.tryReauthenticate(password: password);
                        if (errorKey != null) {
                          messenger.showSnackBar(SnackBar(
                            content: Text(localizeError(l10n, errorKey)),
                            backgroundColor: errorColor,
                          ));
                          return;
                        }

                        if (!context.mounted) return;
                        await showLottieLoader(
                          context,
                          task: () async {
                            try { await memberRepo.delete(memberId); } catch (_) {}
                            try { await authRepo.deleteAccount(); } catch (_) {}
                            return true;
                          },
                          onDone: () => router.go('/directory'),
                          successBuilder: (close) =>
                              _DeleteSuccessScreen(onContinue: close),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.error,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.button),
                        elevation: 0,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: Text(context.l10n.btnDelete),
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

class _ProfileContent extends ConsumerWidget {
  final Member member;

  const _ProfileContent({required this.member});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(myProfileProvider);
    final statsAsync = ref.watch(profileStatsProvider(member.id));
    final contactsEnabled =
        ref.watch(settingsProvider).value?.notifyContacts ?? true;
    final colors = context.colors;

    final stats = statsAsync.value ??
        ProfileStats(
          weeklyViews: 0,
          whatsappContacts: 0,
          activeServices: member.offers.length,
        );

    return Column(
      children: [
        FadeInDown(
          duration: const Duration(milliseconds: 400),
          child: _TopBar(status: profileState.status, member: member),
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
  final Member member;

  const _TopBar({required this.status, required this.member});

  Future<void> _share(BuildContext context) async {
    final url = 'https://ipuc-pis-directory.web.app/member?id=${member.id}';
    final text = '${member.name} está en el Directorio IPUC Pisarreal 🙏\n$url';
    try {
      await SharePlus.instance.share(ShareParams(text: text));
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: url));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enlace copiado al portapapeles')),
        );
      }
    }
  }

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
            child: GestureDetector(
              onTap: () => _share(context),
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

class _DeleteSuccessScreen extends StatelessWidget {
  final VoidCallback onContinue;
  const _DeleteSuccessScreen({required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final padding = MediaQuery.of(context).padding;
    return Material(
      color: colors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: colors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete_outline,
                    color: colors.error, size: 48),
              ),
              const SizedBox(height: AppSpacing.x6),
              Text(
                context.l10n.deleteSuccessTitle,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: AppTypography.size2xl,
                  fontWeight: AppTypography.extrabold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                context.l10n.deleteSuccessBody,
                style: AppTypography.bodyMd
                    .copyWith(color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.textOnPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.button),
                    elevation: 0,
                  ),
                  child: Text(
                    context.l10n.btnContinue,
                    style: const TextStyle(
                        fontSize: AppTypography.sizeLg,
                        fontWeight: AppTypography.semibold),
                  ),
                ),
              ),
              SizedBox(height: padding.bottom > 0 ? 0 : AppSpacing.x4),
            ],
          ),
        ),
      ),
    );
  }
}
