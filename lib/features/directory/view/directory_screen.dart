import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../model/member.dart';
import '../provider/directory_provider.dart';
import '../repository/member_repository.dart';
import 'widgets/category_filter_bar.dart';
import 'widgets/member_card.dart';

class DirectoryScreen extends ConsumerWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(directoryProvider);
    final notifier = ref.read(directoryProvider.notifier);
    final filteredAsync = ref.watch(filteredMembersProvider);
    final totalAsync = ref.watch(membersStreamProvider);

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
                          child: MemberCard(member: members[i]),
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
          onPressed: () => context.push('/register'),
          backgroundColor: kAccentBlue,
          child: const Icon(Icons.add, color: Colors.white),
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
              Text(
                'IGLESIA PENTECOSTAL UNIDA DE COLOMBIA',
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onSettingsTap,
                child: Icon(Icons.settings_outlined,
                    color: colors.textSecondary, size: 22),
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

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 6,
      itemBuilder: (context, i) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 82,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const _ShimmerBar(),
      ),
    );
  }
}

class _ShimmerBar extends StatefulWidget {
  const _ShimmerBar();

  @override
  State<_ShimmerBar> createState() => _ShimmerBarState();
}

class _ShimmerBarState extends State<_ShimmerBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.7).animate(_ctrl);
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
      builder: (_, child) => Opacity(
        opacity: _anim.value,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: kAccentBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 14,
                      width: 160,
                      decoration: BoxDecoration(
                        color: kAccentBlue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 10,
                      width: 100,
                      decoration: BoxDecoration(
                        color: kAccentBlue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 48, color: colors.textSecondary),
          const SizedBox(height: 16),
          Text(
            hasFilter
                ? 'Sin resultados para tu búsqueda'
                : 'El directorio está vacío',
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
