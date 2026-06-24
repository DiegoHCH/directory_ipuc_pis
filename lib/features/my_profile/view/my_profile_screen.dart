import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/member_avatar.dart';
import '../../directory/model/member.dart';
import '../provider/current_member_provider.dart';
import '../provider/my_profile_provider.dart';
import '../provider/profile_stats_provider.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberAsync = ref.watch(currentMemberProvider);

    return Scaffold(
      body: SafeArea(
        child: memberAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator(color: kAccentBlue)),
          error: (e, _) => _MessageView(
            icon: Icons.error_outline,
            message: 'No se pudo cargar tu perfil.',
          ),
          data: (member) => member == null
              ? const _NotLoggedIn()
              : _ProfileContent(member: member),
        ),
      ),
    );
  }
}

class _ProfileContent extends ConsumerWidget {
  final Member member;

  const _ProfileContent({required this.member});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(myProfileProvider);
    final statsAsync = ref.watch(profileStatsProvider(member.id));
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
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    ZoomIn(
                      duration: const Duration(milliseconds: 500),
                      child: Center(
                        child: MemberAvatar(
                            member: member, size: 90, circle: true),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      duration: const Duration(milliseconds: 400),
                      child: Column(
                        children: [
                          const Center(
                            child: Text(
                              'MI PERFIL',
                              style: TextStyle(
                                color: kAccentBlue,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.4,
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
                              style: TextStyle(
                                color: colors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Center(
                            child: Text(
                              member.description,
                              style: TextStyle(
                                  color: colors.textSecondary, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(milliseconds: 400),
                      child: _StatsRow(
                        stats: stats.copyWith(
                          activeServices: member.offers.length,
                        ),
                        isLoading: statsAsync.isLoading,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FadeInUp(
                      delay: const Duration(milliseconds: 300),
                      duration: const Duration(milliseconds: 400),
                      child: _OffersSection(member: member),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            FadeInUp(
              delay: const Duration(milliseconds: 350),
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        context.push('/edit-profile', extra: member),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text(
                      'Editar mi perfil',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                  ),
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline, size: 48, color: colors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'Inicia sesión para ver tu perfil',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => context.go('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Iniciar sesión',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
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
          const SizedBox(height: 16),
          Text(message,
              style: TextStyle(color: colors.textPrimary, fontSize: 15)),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () =>
                  context.canPop() ? context.pop() : context.go('/directory'),
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
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  status.label,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(10),
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

  const _StatsRow({required this.stats, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final v = isLoading ? '—' : null;
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            _StatCell(
                value: v ?? '${stats.weeklyViews}',
                label: 'Vistas esta\nsemana'),
            _Divider(),
            _StatCell(
                value: v ?? '${stats.whatsappContacts}',
                label: 'Contactos por\nWhatsApp'),
            _Divider(),
            _StatCell(
                value: '${stats.activeServices}',
                label: 'Servicios\nactivos'),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;

  const _StatCell({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: colors.textSecondary, fontSize: 11, height: 1.4),
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
      indent: 12,
      endIndent: 12,
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
              'LO QUE OFRECES',
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
              ),
            ),
            GestureDetector(
              onTap: () => context.push('/edit-profile', extra: member),
              child: const Text(
                'EDITAR',
                style: TextStyle(
                  color: kAccentBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (member.offers.isEmpty)
          Text('Aún no has agregado servicios.',
              style: TextStyle(color: colors.textSecondary, fontSize: 13))
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: member.offers
                .map(
                  (o) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: kAccentBlue.withValues(alpha: 0.4)),
                    ),
                    child: Text(o,
                        style: TextStyle(
                            color: colors.textPrimary, fontSize: 13)),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
