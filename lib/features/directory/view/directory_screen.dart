import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../model/member.dart';
import '../provider/directory_provider.dart';
import '../repository/member_repository.dart';
import '../../my_profile/provider/current_member_provider.dart';
import '../../../core/providers/notification_listener_provider.dart';
import '../../../core/widgets/notification_permission_dialog.dart';
import '../../../features/settings/provider/settings_provider.dart';
import 'widgets/category_filter_bar.dart';
import 'widgets/member_card.dart';
import '../../../core/extensions/l10n_extension.dart';

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
    ref.watch(notificationListenerProvider);
    final myId = ref.watch(currentMemberProvider).valueOrNull?.id ?? '';

    final filter = ref.watch(directoryProvider);
    final notifier = ref.read(directoryProvider.notifier);
    final filteredAsync = ref.watch(filteredMembersProvider);
    final totalAsync = ref.watch(membersStreamProvider);
    final myId2 = ref.watch(currentMemberProvider).valueOrNull?.id;
    final colors = context.colors;

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
            const SizedBox(height: AppSpacing.x5),
            FadeInDown(
              delay: const Duration(milliseconds: 100),
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
                child: _SearchBar(onChanged: notifier.setSearchQuery),
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            FadeInLeft(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.only(left: AppSpacing.x5),
                child: CategoryFilterBar(
                  selected: filter.selectedCategory,
                  onSelected: notifier.setCategory,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.x5),
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
          backgroundColor: colors.primary,
          child: Icon(
            myId2 != null ? Icons.person : Icons.add,
            color: colors.textOnPrimary,
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
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.x5, AppSpacing.x4, AppSpacing.x5, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.dirChurch,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 10,
                    letterSpacing: AppTypography.trackingWide,
                    fontWeight: AppTypography.medium,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
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
            context.l10n.dirTitle,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: 30,
              fontWeight: AppTypography.extrabold,
              height: AppTypography.lineHeightTight,
            ),
          ),
          Text(
            context.l10n.dirSubtitle,
            style: TextStyle(
              color: colors.primary,
              fontSize: 30,
              fontWeight: AppTypography.extrabold,
              height: AppTypography.lineHeightTight,
            ),
          ),
          Text(
            context.l10n.dirChurchShort,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: AppTypography.sizeXl,
              fontWeight: AppTypography.semibold,
              height: AppTypography.lineHeightSnug,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            totalMembers == 0
                ? context.l10n.dirQuoteEmpty
                : context.l10n.dirQuoteWithCount(totalMembers),
            style: TextStyle(
                color: colors.textSecondary,
                fontSize: AppTypography.sizeMd),
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
        borderRadius: AppRadius.input,
        border: Border.all(color: colors.textSecondary.withValues(alpha: 0.2)),
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(
            color: colors.textPrimary, fontSize: AppTypography.sizeBase),
        decoration: InputDecoration(
          hintText: context.l10n.dirSearch,
          hintStyle: TextStyle(
              color: colors.textSecondary, fontSize: AppTypography.sizeBase),
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
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x5),
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
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4, vertical: 14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppRadius.button,
      ),
      child: ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => gradient.createShader(bounds),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: base.withValues(alpha: 0.1),
                borderRadius: AppRadius.input,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: base.withValues(alpha: 0.1),
                      borderRadius: AppRadius.brSm,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    height: 11,
                    width: 140,
                    decoration: BoxDecoration(
                      color: base.withValues(alpha: 0.07),
                      borderRadius: AppRadius.brSm,
                    ),
                  ),
                  const SizedBox(height: 7),
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
                          borderRadius: AppRadius.brSm,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: base.withValues(alpha: 0.07),
                borderRadius: AppRadius.brXs,
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
        padding: const EdgeInsets.all(AppSpacing.x8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined,
                size: 48, color: colors.textSecondary),
            const SizedBox(height: AppSpacing.x4),
            Text(
              context.l10n.dirErrorLoad,
              style: AppTypography.titleLg.copyWith(
                color: colors.textPrimary,
                fontWeight: AppTypography.semibold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              message,
              style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: AppTypography.sizeSm),
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
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x10),
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
              const SizedBox(height: AppSpacing.x5),
              Text(
                context.l10n.dirNoResults,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 18,
                  fontWeight: AppTypography.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                context.l10n.dirNoResultsSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: AppTypography.sizeBase,
                    height: AppTypography.lineHeightNormal),
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: colors.primaryMuted,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.people_outline_rounded,
                  size: 42, color: colors.primary),
            ),
            const SizedBox(height: AppSpacing.x6),
            Text(
              context.l10n.dirBeFirst,
              style: TextStyle(
                color: colors.primary,
                fontSize: 22,
                fontWeight: AppTypography.extrabold,
                height: AppTypography.lineHeightTight,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              context.l10n.dirEmptySubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: AppTypography.sizeBase,
                  height: AppTypography.lineHeightRelaxed),
            ),
            const SizedBox(height: AppSpacing.x7),
            ElevatedButton.icon(
              onPressed: () => context.push('/register'),
              icon: const Icon(Icons.add, size: 18),
              label: Text(
                context.l10n.btnCreateProfile,
                style: const TextStyle(
                    fontSize: AppTypography.sizeLg,
                    fontWeight: AppTypography.semibold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.textOnPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.button),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x6, vertical: 14),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
