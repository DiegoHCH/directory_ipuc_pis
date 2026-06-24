import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../model/member.dart';
import '../provider/directory_provider.dart';
import '../repository/member_repository.dart';
import '../../my_profile/provider/current_member_provider.dart';
import '../../../core/providers/notification_listener_provider.dart';
import '../../../core/widgets/notification_permission_dialog.dart';
import '../../../features/settings/provider/settings_provider.dart';
import 'widgets/category_filter_bar.dart';
import 'widgets/member_card.dart';

class DirectoryScreen extends ConsumerStatefulWidget {
  const DirectoryScreen({super.key});

  @override
  ConsumerState<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends ConsumerState<DirectoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      maybeAskNotificationPermission(
        context,
        onAccepted: () =>
            ref.read(settingsProvider.notifier).toggleNotifyNewMembers(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Activa listener de nuevos miembros
    ref.watch(notificationListenerProvider);
    final myId = ref.watch(currentMemberProvider).valueOrNull?.id ?? '';

    final filter = ref.watch(directoryProvider);
    final notifier = ref.read(directoryProvider.notifier);
    final filteredAsync = ref.watch(filteredMembersProvider);
    final totalAsync = ref.watch(membersStreamProvider);
    final myId2 = ref.watch(currentMemberProvider).valueOrNull?.id;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: _Header(
                totalMembers: totalAsync.valueOrNull?.length ?? 0,
                onSettingsTap: () => context.push('/settings'),
              ),
            ),
            const SizedBox(height: 20),
            FadeInDown(
              delay: const Duration(milliseconds: 100),
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SearchBar(onChanged: notifier.setSearchQuery),
              ),
            ),
            const SizedBox(height: 16),
            FadeInLeft(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: CategoryFilterBar(
                  selected: filter.selectedCategory,
                  onSelected: notifier.setCategory,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredAsync.when(
                loading: () => const _LoadingList(),
                error: (e, _) => _ErrorView(message: e.toString()),
                data: (members) => members.isEmpty
                    ? _EmptyView(
                        hasFilter: filter.searchQuery.isNotEmpty ||
                            filter.selectedCategory != MemberCategory.all,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: members.length,
                        itemBuilder: (_, i) => FadeInUp(
                          delay: Duration(
                              milliseconds: (i * 70).clamp(0, 350)),
                          duration: const Duration(milliseconds: 400),
                          child: MemberCard(
                          member: members[i],
                          isMe: members[i].id == myId,
                        ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: const Duration(milliseconds: 400),
        child: FloatingActionButton(
          onPressed: () =>
              context.push(myId2 != null ? '/my-profile' : '/register'),
          backgroundColor: kAccentBlue,
          child: Icon(
            myId2 != null ? Icons.person : Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final int totalMembers;
  final VoidCallback onSettingsTap;

  const _Header({required this.totalMembers, required this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'IGLESIA PENTECOSTAL UNIDA DE COLOMBIA',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 10,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onSettingsTap,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(Icons.settings_outlined,
                      color: colors.textSecondary, size: 22),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Directorio',
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const Text(
            'Hermanos.',
            style: TextStyle(
              color: kAccentBlue,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          Text(
            'IPUC Pisarreal',
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            totalMembers == 0
                ? '«Un Señor, una fe, un bautismo.»'
                : '«Un Señor, una fe, un bautismo.» — $totalMembers hermanos ofreciendo su trabajo.',
            style: TextStyle(color: colors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ── Search ────────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.textSecondary.withValues(alpha: 0.2)),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: colors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Busca por nombre o servicio...',
          hintStyle: TextStyle(color: colors.textSecondary, fontSize: 14),
          prefixIcon:
              Icon(Icons.search, color: colors.textSecondary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// ── Estados ───────────────────────────────────────────────────────────────────

class _LoadingList extends StatefulWidget {
  const _LoadingList();

  @override
  State<_LoadingList> createState() => _LoadingListState();
}

class _LoadingListState extends State<_LoadingList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _anim = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 6,
        itemBuilder: (context, i) => _SkeletonCard(shimmerValue: _anim.value),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final double shimmerValue;

  const _SkeletonCard({required this.shimmerValue});


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Colors.white : Colors.black;

    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        base.withValues(alpha: 0.06),
        base.withValues(alpha: 0.13),
        base.withValues(alpha: 0.06),
      ],
      stops: const [0.0, 0.5, 1.0],
      transform: _ShimmerTransform(shimmerValue),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => gradient.createShader(bounds),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: base.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: base.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 7),
                  // Descripción
                  Container(
                    height: 11,
                    width: 140,
                    decoration: BoxDecoration(
                      color: base.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 7),
                  // Categoría
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: base.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        height: 10,
                        width: 70,
                        decoration: BoxDecoration(
                          color: base.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Chevron
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: base.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerTransform extends GradientTransform {
  final double value;
  const _ShimmerTransform(this.value);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * value, 0, 0);
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined,
                size: 48, color: colors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No se pudo cargar el directorio',
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: colors.textSecondary, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final bool hasFilter;

  const _EmptyView({required this.hasFilter});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (hasFilter) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.search_off_rounded,
                    size: 34, color: colors.textSecondary),
              ),
              const SizedBox(height: 20),
              Text(
                'Sin resultados',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Intenta con otro nombre o cambia la categoría.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: colors.textSecondary, fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: kAccentBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.people_outline_rounded,
                  size: 42, color: kAccentBlue),
            ),
            const SizedBox(height: 24),
            const Text(
              'Sé el primero',
              style: TextStyle(
                color: kAccentBlue,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'El directorio está vacío. Únete y comparte tus servicios con la comunidad.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: colors.textSecondary, fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => context.push('/register'),
              icon: const Icon(Icons.add, size: 18),
              label: const Text(
                'Crear mi perfil',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 14),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
