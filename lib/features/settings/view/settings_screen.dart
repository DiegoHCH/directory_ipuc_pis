import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/repository/auth_repository.dart';
import '../../my_profile/provider/current_member_provider.dart';
import '../provider/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final colors = context.colors;
    final settings = settingsAsync.valueOrNull;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.chevron_left,
                          color: colors.textPrimary, size: 22),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Configuración',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
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
                    const SizedBox(height: 24),
                    FadeInLeft(
                      duration: const Duration(milliseconds: 400),
                      child: _SectionLabel('APARIENCIA'),
                    ),
                    const SizedBox(height: 10),
                    FadeInUp(
                      duration: const Duration(milliseconds: 400),
                      child: _AppearanceCard(),
                    ),
                    const SizedBox(height: 24),
                    FadeInLeft(
                      delay: const Duration(milliseconds: 150),
                      duration: const Duration(milliseconds: 400),
                      child: _SectionLabel('NOTIFICACIONES'),
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
                    const SizedBox(height: 24),
                    FadeInLeft(
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 400),
                      child: _SectionLabel('CUENTA'),
                    ),
                    const SizedBox(height: 10),
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 400),
                      child: _AccountCard(),
                    ),
                    const SizedBox(height: 32),
                    FadeIn(
                      delay: const Duration(milliseconds: 450),
                      duration: const Duration(milliseconds: 500),
                      child: Center(
                      child: Text(
                        'Directorio Hermanos · v1.0\nIglesia Pentecostal Unida de Colombia',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 12,
                          height: 1.6,
                        ),
                      ),
                    ),
                    ),
                    const SizedBox(height: 24),
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
        fontSize: 11,
        fontWeight: FontWeight.w700,
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

    const options = [
      (ThemeMode.system, 'Automático', 'Sigue el sistema de tu teléfono',
          Icons.contrast),
      (ThemeMode.light, 'Claro', '', Icons.wb_sunny_outlined),
      (ThemeMode.dark, 'Oscuro', '', Icons.dark_mode_outlined),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
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
            onTap: () => ref.read(themeProvider.notifier).state = mode,
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? kAccentBlue
                        : kAccentBlue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : kAccentBlue,
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
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                              color: colors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                isSelected
                    ? const Icon(Icons.check_circle,
                        color: kAccentBlue, size: 22)
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
              endIndent: 16,
              color: colors.textSecondary.withValues(alpha: 0.12),
            ),
        ],
      ),
    );
  }
}

// ── Notificaciones ────────────────────────────────────────────────────────────

class _NotificationsCard extends StatelessWidget {
  final SettingsState settings;
  final SettingsNotifier notifier;

  const _NotificationsCard(
      {required this.settings, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _ToggleRow(
            label: 'Avisarme de nuevos hermanos',
            value: settings.notifyNewMembers,
            onToggle: () => notifier.toggleNotifyNewMembers(),
            showDivider: true,
          ),
          _ToggleRow(
            label: 'Contactos a mi perfil',
            value: settings.notifyContacts,
            onToggle: () => notifier.toggleNotifyContacts(),
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
  final VoidCallback onToggle;
  final bool showDivider;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onToggle,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(label,
                    style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w400)),
              ),
              Switch(
                value: value,
                onChanged: (_) => onToggle(),
                activeThumbColor: Colors.white,
                activeTrackColor: kAccentBlue,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
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

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _NavRow(
            label: 'Mi perfil',
            onTap: () => context.push(isLoggedIn ? '/my-profile' : '/login'),
            showDivider: true,
          ),
          _NavRow(
              label: 'Ayuda y soporte', onTap: () {}, showDivider: true),
          GestureDetector(
            onTap: () async {
              if (isLoggedIn) {
                await ref.read(authRepositoryProvider).signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sesión cerrada.')),
                  );
                }
              } else {
                context.push('/login');
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  isLoggedIn ? 'Cerrar sesión' : 'Iniciar sesión',
                  style: TextStyle(
                    color: isLoggedIn
                        ? const Color(0xFFEF5350)
                        : kAccentBlue,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(label,
                      style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w400)),
                ),
                Icon(Icons.chevron_right,
                    color: colors.textSecondary, size: 20),
              ],
            ),
          ),
          if (showDivider)
            Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: colors.textSecondary.withValues(alpha: 0.12),
            ),
        ],
      ),
    );
  }
}
