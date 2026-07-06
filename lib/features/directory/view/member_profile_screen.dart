import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/member_avatar.dart';
import '../model/member.dart';
import '../../auth/repository/auth_repository.dart';
import '../../my_profile/provider/current_member_provider.dart';
import '../../my_profile/provider/my_profile_provider.dart';
import '../../../core/extensions/l10n_extension.dart';

class MemberProfileScreen extends ConsumerStatefulWidget {
  final Member member;

  const MemberProfileScreen({super.key, required this.member});

  @override
  ConsumerState<MemberProfileScreen> createState() =>
      _MemberProfileScreenState();
}

class _MemberProfileScreenState extends ConsumerState<MemberProfileScreen> {
  @override
  void initState() {
    super.initState();
    _recordView();
  }

  Future<void> _recordView() async {
    final myUid = ref.read(authRepositoryProvider).currentUser?.uid;
    if (myUid == widget.member.id) return;
    await FirebaseFirestore.instance.collection('profile_views').add({
      'memberId': widget.member.id,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final member = widget.member;
    final isBookmarked = ref.watch(bookmarkProvider(member.id));
    final colors = context.colors;
    final categoryColor = colors.categoryColor(member.category.tag);

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
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.x6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.x6),
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
                              member.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.headingMd.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                          if (member.category != MemberCategory.buscador) ...[
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
                                      fontSize: AppTypography.sizeSm,
                                      fontWeight: AppTypography.semibold,
                                      letterSpacing: AppTypography.trackingNormal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (member.description.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Center(
                              child: Text(
                                member.description,
                                style: AppTypography.titleLg.copyWith(
                                  color: colors.primary,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (member.bio.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.x5),
                      FadeIn(
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(milliseconds: 500),
                        child: Text(
                          member.bio,
                          style: AppTypography.bodyMd.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                    if (member.offers.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.x6),
                      FadeInUp(
                        delay: const Duration(milliseconds: 280),
                        duration: const Duration(milliseconds: 400),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.profileWhatTheyOffer,
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontSize: AppTypography.sizeXs,
                                fontWeight: AppTypography.bold,
                                letterSpacing: AppTypography.trackingWider,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.x3),
                            _OffersWrap(offers: member.offers),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.x6),
                    FadeInUp(
                      delay: const Duration(milliseconds: 360),
                      duration: const Duration(milliseconds: 400),
                      child: _PhoneCard(phone: member.phone),
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    FadeInUp(
                      delay: const Duration(milliseconds: 420),
                      duration: const Duration(milliseconds: 400),
                      child: _WhatsAppButton(member: member),
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
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4, vertical: AppSpacing.x2),
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
          const SizedBox(width: AppSpacing.x2),
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
          borderRadius: AppRadius.iconButton,
        ),
        child: Icon(icon, color: context.colors.textPrimary, size: 20),
      ),
    );
  }
}

class _OffersWrap extends StatelessWidget {
  final List<String> offers;

  const _OffersWrap({required this.offers});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      spacing: AppSpacing.x2,
      runSpacing: AppSpacing.x2,
      children: offers
          .map(
            (o) => Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: AppSpacing.x2),
              decoration: BoxDecoration(
                borderRadius: AppRadius.chip,
                border: Border.all(
                    color: colors.primary.withValues(alpha: 0.5)),
              ),
              child: Text(
                o,
                style: TextStyle(
                    color: colors.textPrimary,
                    fontSize: AppTypography.sizeMd),
              ),
            ),
          )
          .toList(),
    );
  }
}

void _requireAuth(BuildContext context, WidgetRef ref, VoidCallback action) {
  final user = ref.read(authRepositoryProvider).currentUser;
  if (user != null) {
    action();
    return;
  }
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _AuthRequiredSheet(
      onSignIn: () => context.push('/login'),
    ),
  );
}

class _PhoneCard extends ConsumerWidget {
  final String phone;

  const _PhoneCard({required this.phone});

  Future<void> _call(BuildContext context) async {
    final digits = phone.replaceAll(' ', '');
    final uri = Uri(scheme: 'tel', path: digits);
    try {
      await launchUrl(uri);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.errOpenDialer)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    return GestureDetector(
      onTap: () => _requireAuth(context, ref, () => _call(context)),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.button,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.primaryMuted,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.phone, color: colors.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.profilePhone,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 10,
                    fontWeight: AppTypography.semibold,
                    letterSpacing: AppTypography.trackingWide,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  phone,
                  style: AppTypography.titleLg.copyWith(
                    color: colors.textPrimary,
                    fontWeight: AppTypography.semibold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WhatsAppButton extends ConsumerWidget {
  final Member member;

  const _WhatsAppButton({required this.member});

  Future<void> _openWhatsApp(BuildContext context, WidgetRef ref) async {
    final digits = member.phone.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri.parse('https://wa.me/$digits');

    final me = ref.read(currentMemberProvider).valueOrNull;
    FirebaseFirestore.instance.collection('contact_events').add({
      'toId': member.id,
      'fromName': me?.name ?? 'Un hermano',
      'createdAt': FieldValue.serverTimestamp(),
    });

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.errOpenWhatsApp)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: () =>
            _requireAuth(context, ref, () => _openWhatsApp(context, ref)),
        icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 20),
        label: Text(
          context.l10n.btnContactWhatsApp,
          style: const TextStyle(
              fontSize: AppTypography.sizeLg,
              fontWeight: AppTypography.semibold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.whatsapp,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
          elevation: 0,
        ),
      ),
    );
  }
}

class _AuthRequiredSheet extends StatelessWidget {
  final VoidCallback onSignIn;
  const _AuthRequiredSheet({required this.onSignIn});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.x6,
        AppSpacing.x6,
        AppSpacing.x6,
        AppSpacing.x6 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: colors.textSecondary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.x6),
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: colors.primaryMuted, shape: BoxShape.circle,
            ),
            child: Icon(Icons.lock_outline, color: colors.primary, size: 30),
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            context.l10n.authDialogTitle,
            style: TextStyle(
              color: colors.textPrimary,
              fontSize: AppTypography.size2xl,
              fontWeight: AppTypography.extrabold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.authDialogBody,
            style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x6),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onSignIn();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.textOnPrimary,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
                elevation: 0,
              ),
              child: Text(
                context.l10n.btnSignIn,
                style: const TextStyle(
                    fontSize: AppTypography.sizeLg,
                    fontWeight: AppTypography.semibold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              context.l10n.btnCancel,
              style: AppTypography.bodyMd.copyWith(color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

