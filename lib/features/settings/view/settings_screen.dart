import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/providers/support_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../auth/repository/auth_repository.dart';
import '../../my_profile/provider/current_member_provider.dart';
import '../provider/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(settingsProvider.notifier).syncPermissionStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final colors = context.colors;
    final settings = settingsAsync.value;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x4, vertical: AppSpacing.x3),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
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
                  const SizedBox(width: 14),
                  Text(
                    context.l10n.settingsTitle,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: AppTypography.size2xl,
                      fontWeight: AppTypography.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.x6),
                    FadeInLeft(
                      duration: const Duration(milliseconds: 400),
                      child: _SectionLabel(context.l10n.settingsAppearance),
                    ),
                    const SizedBox(height: 10),
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      child: _AppearanceCard(),
                    ),
                    const SizedBox(height: AppSpacing.x6),
                    FadeInLeft(
                      delay: const Duration(milliseconds: 150),
                      duration: const Duration(milliseconds: 400),
                      child: _SectionLabel(context.l10n.settingsNotifications),
                    ),
                    const SizedBox(height: 10),
                    FadeInUp(
                      delay: const Duration(milliseconds: 150),
                      duration: const Duration(milliseconds: 400),
                      child: _NotificationsCard(
                        settings: settings ?? const SettingsState(),
                        notifier: notifier,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x6),
                    FadeInLeft(
                      delay: const Duration(milliseconds: 225),
                      duration: const Duration(milliseconds: 400),
                      child: _SectionLabel(context.l10n.settingsLanguage),
                    ),
                    const SizedBox(height: 10),
                    FadeInUp(
                      delay: const Duration(milliseconds: 225),
                      duration: const Duration(milliseconds: 400),
                      child: const _LanguageCard(),
                    ),
                    const SizedBox(height: AppSpacing.x6),
                    FadeInLeft(
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 400),
                      child: _SectionLabel(context.l10n.settingsAccount),
                    ),
                    const SizedBox(height: 10),
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 400),
                      child: _AccountCard(),
                    ),
                    const SizedBox(height: AppSpacing.x8),
                    FadeIn(
                      delay: const Duration(milliseconds: 450),
                      duration: const Duration(milliseconds: 500),
                      child: Center(
                        child: Text(
                          context.l10n.settingsFooter,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: AppTypography.sizeSm,
                            height: AppTypography.lineHeightRelaxed,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x6),
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

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: context.colors.textSecondary,
        fontSize: AppTypography.sizeXs,
        fontWeight: AppTypography.bold,
        letterSpacing: 1.3,
      ),
    );
  }
}

// ── Apariencia ────────────────────────────────────────────────────────────────

class _AppearanceCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(themeProvider);
    final colors = context.colors;

    final options = [
      (ThemeMode.system, context.l10n.settingsThemeAuto, context.l10n.settingsThemeAutoDesc, Icons.contrast),
      (ThemeMode.light, context.l10n.settingsThemeLight, '', Icons.wb_sunny_outlined),
      (ThemeMode.dark, context.l10n.settingsThemeDark, '', Icons.dark_mode_outlined),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.card,
      ),
      child: Column(
        children: options.indexed.map(((int, dynamic) e) {
          final (index, opt) = e;
          final (mode, label, subtitle, icon) =
              opt as (ThemeMode, String, String, IconData);
          final isSelected = mode == current;
          final isLast = index == options.length - 1;

          return _ThemeRow(
            mode: mode,
            label: label,
            subtitle: subtitle,
            icon: icon,
            isSelected: isSelected,
            showDivider: !isLast,
            onTap: () => ref.read(themeProvider.notifier).setMode(mode),
          );
        }).toList(),
      ),
    );
  }
}

class _ThemeRow extends StatelessWidget {
  final ThemeMode mode;
  final String label;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final bool showDivider;
  final VoidCallback onTap;

  const _ThemeRow({
    required this.mode,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.showDivider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x4, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.primary
                        : colors.primaryMuted,
                    borderRadius: AppRadius.iconButton,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : colors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: AppTypography.titleLg.copyWith(
                          color: colors.textPrimary,
                          fontWeight: AppTypography.medium,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: AppTypography.sizeSm),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                isSelected
                    ? Icon(Icons.check_circle, color: colors.primary, size: 22)
                    : Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: colors.textSecondary
                                  .withValues(alpha: 0.4),
                              width: 1.5),
                        ),
                      ),
              ],
            ),
          ),
          if (showDivider)
            Divider(
              height: 1,
              indent: 68,
              endIndent: AppSpacing.x4,
              color: colors.textSecondary.withValues(alpha: 0.12),
            ),
        ],
      ),
    );
  }
}

// ── Notificaciones ────────────────────────────────────────────────────────────

class _NotificationsCard extends ConsumerWidget {
  final SettingsState settings;
  final SettingsNotifier notifier;

  const _NotificationsCard(
      {required this.settings, required this.notifier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.card,
      ),
      child: Column(
        children: [
          _ToggleRow(
            label: context.l10n.settingsNotifyNewMembers,
            value: settings.notifyNewMembers,
            onToggle: () => notifier.toggleNotifyNewMembers(),
            showDivider: true,
          ),
          _ToggleRow(
            label: context.l10n.settingsNotifyContacts,
            value: isLoggedIn ? settings.notifyContacts : false,
            enabled: isLoggedIn,
            onToggle: isLoggedIn ? () => notifier.toggleNotifyContacts() : null,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final VoidCallback? onToggle;
  final bool showDivider;
  final bool enabled;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onToggle,
    required this.showDivider,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4, vertical: AppSpacing.x1),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.titleLg.copyWith(
                    color: enabled ? colors.textPrimary : colors.textSecondary,
                    fontWeight: AppTypography.regular,
                  ),
                ),
              ),
              Switch(
                value: value,
                onChanged: enabled && onToggle != null
                    ? (_) => onToggle!()
                    : null,
                activeThumbColor: Colors.white,
                activeTrackColor: colors.primary,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: AppSpacing.x4,
            endIndent: AppSpacing.x4,
            color: colors.textSecondary.withValues(alpha: 0.12),
          ),
      ],
    );
  }
}

// ── Cuenta ────────────────────────────────────────────────────────────────────

class _AccountCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.card,
      ),
      child: Column(
        children: [
          _NavRow(
            label: context.l10n.settingsMyProfile,
            onTap: () => context.push(isLoggedIn ? '/my-profile' : '/login'),
            showDivider: true,
          ),
          _NavRow(
            label: context.l10n.settingsHelp,
            showDivider: true,
            onTap: () async {
              final msg = Uri.encodeComponent(context.l10n.settingsHelpMessage);
              final support = await ref.read(supportContactProvider.future);
              if (support.phone.isEmpty) return;
              final uri = Uri.parse('https://wa.me/${support.phone}?text=$msg');
              try {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.errOpenWhatsApp)),
                  );
                }
              }
            },
          ),
          _NavRow(
            label: context.l10n.settingsPrivacy,
            showDivider: true,
            onTap: () async {
              final support = await ref.read(supportContactProvider.future);
              if (support.privacyPolicyUrl.isEmpty) return;
              final uri = Uri.parse(support.privacyPolicyUrl);
              try {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.errOpenPrivacy)),
                  );
                }
              }
            },
          ),
          GestureDetector(
            onTap: () async {
              if (isLoggedIn) {
                await ref.read(authRepositoryProvider).signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(context.l10n.successSignedOut)),
                  );
                }
              } else {
                context.push('/login');
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x4, vertical: AppSpacing.x4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  isLoggedIn ? context.l10n.settingsSignOut : context.l10n.btnSignIn,
                  style: AppTypography.titleLg.copyWith(
                    color: isLoggedIn ? colors.error : colors.primary,
                    fontWeight: AppTypography.medium,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Idioma ────────────────────────────────────────────────────────────────────

class _LanguageCard extends ConsumerWidget {
  const _LanguageCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider);
    final colors = context.colors;
    final isSpanish = current.languageCode == 'es';

    final currentFlag =
        isSpanish ? 'assets/flag_colombia.png' : 'assets/flag_usa.png';
    final otherFlag =
        isSpanish ? 'assets/flag_usa.png' : 'assets/flag_colombia.png';
    final otherLabel = isSpanish
        ? context.l10n.settingsLangEnglish
        : context.l10n.settingsLangSpanish;
    final next = isSpanish ? const Locale('en') : const Locale('es');

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.card,
      ),
      child: GestureDetector(
        onTap: () => ref.read(localeProvider.notifier).setLocale(next),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4, vertical: 14),
          child: Row(
            children: [
              // Idioma activo
              ClipOval(
                child: Image.asset(
                  currentFlag,
                  width: 38,
                  height: 38,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.arrow_forward,
                  color: colors.textSecondary, size: 16),
              const SizedBox(width: 12),
              // Idioma al que cambia
              ClipOval(
                child: Image.asset(
                  otherFlag,
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                  color: Colors.white.withValues(alpha: 0.5),
                  colorBlendMode: BlendMode.modulate,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                otherLabel,
                style: AppTypography.titleLg.copyWith(
                  color: colors.textSecondary,
                  fontWeight: AppTypography.regular,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool showDivider;

  const _NavRow(
      {required this.label,
      required this.onTap,
      required this.showDivider});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x4, vertical: AppSpacing.x4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.titleLg.copyWith(
                      color: colors.textPrimary,
                      fontWeight: AppTypography.regular,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right,
                    color: colors.textSecondary, size: 20),
              ],
            ),
          ),
          if (showDivider)
            Divider(
              height: 1,
              indent: AppSpacing.x4,
              endIndent: AppSpacing.x4,
              color: colors.textSecondary.withValues(alpha: 0.12),
            ),
        ],
      ),
    );
  }
}
