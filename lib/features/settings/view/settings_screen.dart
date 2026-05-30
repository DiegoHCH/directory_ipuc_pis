import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_notifier.dart';
import '../viewmodel/settings_viewmodel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = SettingsViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) => _SettingsBody(viewModel: _viewModel),
      ),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  final SettingsViewModel viewModel;

  const _SettingsBody({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SafeArea(
      child: Column(
        children: [
          _TopBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _SectionLabel('APARIENCIA'),
                  const SizedBox(height: 10),
                  _AppearanceCard(),
                  const SizedBox(height: 24),
                  _SectionLabel('NOTIFICACIONES'),
                  const SizedBox(height: 10),
                  _NotificationsCard(viewModel: viewModel),
                  const SizedBox(height: 24),
                  _SectionLabel('CUENTA'),
                  const SizedBox(height: 10),
                  _AccountCard(),
                  const SizedBox(height: 32),
                  Center(
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
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
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

class _AppearanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = ThemeProvider.of(context);
    final current = themeNotifier.mode;
    final colors = context.colors;

    final options = [
      _ThemeOption(
        mode: ThemeMode.system,
        label: 'Automático',
        subtitle: 'Sigue el sistema de tu teléfono',
        icon: Icons.contrast,
      ),
      _ThemeOption(
        mode: ThemeMode.light,
        label: 'Claro',
        subtitle: 'Fondo blanco, texto azul',
        icon: Icons.wb_sunny_outlined,
      ),
      _ThemeOption(
        mode: ThemeMode.dark,
        label: 'Oscuro',
        subtitle: 'Fondo azul noche IPUC',
        icon: Icons.dark_mode_outlined,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: options.asMap().entries.map((e) {
          final index = e.key;
          final option = e.value;
          final isSelected = option.mode == current;
          final isLast = index == options.length - 1;

          return _ThemeRow(
            option: option,
            isSelected: isSelected,
            showDivider: !isLast,
            onTap: () => themeNotifier.setMode(option.mode),
          );
        }).toList(),
      ),
    );
  }
}

class _ThemeOption {
  final ThemeMode mode;
  final String label;
  final String subtitle;
  final IconData icon;

  const _ThemeOption({
    required this.mode,
    required this.label,
    required this.subtitle,
    required this.icon,
  });
}

class _ThemeRow extends StatelessWidget {
  final _ThemeOption option;
  final bool isSelected;
  final bool showDivider;
  final VoidCallback onTap;

  const _ThemeRow({
    required this.option,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                    option.icon,
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
                        option.label,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        option.subtitle,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
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
  final SettingsViewModel viewModel;

  const _NotificationsCard({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _ToggleRow(
            label: 'Avisarme de nuevos hermanos',
            value: viewModel.notifyNewMembers,
            onToggle: viewModel.toggleNotifyNewMembers,
            showDivider: true,
          ),
          _ToggleRow(
            label: 'Contactos a mi perfil',
            value: viewModel.notifyContacts,
            onToggle: viewModel.toggleNotifyContacts,
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
                child: Text(
                  label,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
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

class _AccountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _NavRow(
            label: 'Mi perfil',
            onTap: () {},
            showDivider: true,
          ),
          _NavRow(
            label: 'Ayuda y soporte',
            onTap: () {},
            showDivider: true,
          ),
          GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 16),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: Color(0xFFEF5350),
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

  const _NavRow({
    required this.label,
    required this.onTap,
    required this.showDivider,
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
                horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
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
              indent: 16,
              endIndent: 16,
              color: colors.textSecondary.withValues(alpha: 0.12),
            ),
        ],
      ),
    );
  }
}
