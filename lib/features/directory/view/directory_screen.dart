import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../provider/directory_provider.dart';
import 'widgets/category_filter_bar.dart';
import 'widgets/member_card.dart';

class DirectoryScreen extends ConsumerWidget {
  const DirectoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(directoryProvider);
    final notifier = ref.read(directoryProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: _Header(
                totalMembers: state.totalMembers,
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
                  selected: state.selectedCategory,
                  onSelected: notifier.setCategory,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: state.filteredMembers.length,
                itemBuilder: (_, i) => FadeInUp(
                  delay: Duration(milliseconds: (i * 70).clamp(0, 350)),
                  duration: const Duration(milliseconds: 400),
                  child: MemberCard(member: state.filteredMembers[i]),
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
            '«Un Señor, una fe, un bautismo.» — $totalMembers hermanos ofreciendo su trabajo.',
            style: TextStyle(color: colors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

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
