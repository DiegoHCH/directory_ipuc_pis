import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../model/member.dart';
import '../../my_profile/provider/my_profile_provider.dart';

class MemberProfileScreen extends ConsumerWidget {
  final Member member;

  const MemberProfileScreen({super.key, required this.member});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarked = ref.watch(bookmarkProvider(member.id));
    final colors = context.colors;
    final categoryColor = kCategoryColors[member.category.tag] ?? kAccentBlue;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              child: _TopBar(
                isBookmarked: isBookmarked,
                onBookmark: () => ref
                    .read(bookmarkProvider(member.id).notifier)
                    .state = !isBookmarked,
                onShare: () {},
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    ZoomIn(
                      duration: const Duration(milliseconds: 500),
                      child: Center(
                        child: _LargeAvatar(
                            initials: member.initials,
                            surface: colors.surface),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeInUp(
                      delay: const Duration(milliseconds: 100),
                      duration: const Duration(milliseconds: 400),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              member.name,
                              style: TextStyle(
                                color: colors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: categoryColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  member.category.tag,
                                  style: TextStyle(
                                    color: categoryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Center(
                            child: Text(
                              member.description,
                              style: const TextStyle(
                                color: kAccentBlue,
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (member.bio.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      FadeIn(
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          member.bio,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                    if (member.offers.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      FadeInUp(
                        delay: const Duration(milliseconds: 280),
                        duration: const Duration(milliseconds: 400),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LO QUE OFRECE',
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.4,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _OffersWrap(offers: member.offers),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FadeInUp(
                      delay: const Duration(milliseconds: 360),
                      duration: const Duration(milliseconds: 400),
                      child: _PhoneCard(phone: member.phone),
                    ),
                    const SizedBox(height: 16),
                    FadeInUp(
                      delay: const Duration(milliseconds: 420),
                      duration: const Duration(milliseconds: 400),
                      child: _WhatsAppButton(),
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

class _TopBar extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onBookmark;
  final VoidCallback onShare;

  const _TopBar({
    required this.isBookmarked,
    required this.onBookmark,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _IconBtn(
            icon: Icons.chevron_left,
            onTap: () => context.pop(),
            surface: colors.surface,
          ),
          const Spacer(),
          _IconBtn(
            icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            onTap: onBookmark,
            surface: colors.surface,
          ),
          const SizedBox(width: 8),
          _IconBtn(
            icon: Icons.ios_share,
            onTap: onShare,
            surface: colors.surface,
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color surface;

  const _IconBtn(
      {required this.icon, required this.onTap, required this.surface});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: context.colors.textPrimary, size: 20),
      ),
    );
  }
}

class _LargeAvatar extends StatelessWidget {
  final String initials;
  final Color surface;

  const _LargeAvatar({required this.initials, required this.surface});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: surface,
        shape: BoxShape.circle,
        border: Border.all(color: kAccentBlue, width: 2.5),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: kAccentBlue,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _OffersWrap extends StatelessWidget {
  final List<String> offers;

  const _OffersWrap({required this.offers});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: offers
          .map(
            (o) => Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: kAccentBlue.withValues(alpha: 0.5)),
              ),
              child: Text(
                o,
                style: TextStyle(
                    color: context.colors.textPrimary, fontSize: 13),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _PhoneCard extends StatelessWidget {
  final String phone;

  const _PhoneCard({required this.phone});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kAccentBlue.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.phone, color: kAccentBlue, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TELÉFONO',
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                phone,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WhatsAppButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.chat, size: 20),
        label: const Text(
          'Contactar por WhatsApp',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF25D366),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
    );
  }
}
