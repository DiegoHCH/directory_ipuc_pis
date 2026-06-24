import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/member_avatar.dart';
import '../model/member.dart';
import '../../my_profile/provider/current_member_provider.dart';
import '../../my_profile/provider/my_profile_provider.dart';

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
    final myId = ref.read(currentMemberProvider).valueOrNull?.id;
    if (myId == widget.member.id) return; // no graba vista propia
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
                      child: _WhatsAppButton(member: member),
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

  Future<void> _call(BuildContext context) async {
    final digits = phone.replaceAll(' ', '');
    final uri = Uri(scheme: 'tel', path: digits);
    try {
      await launchUrl(uri);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el marcador.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: () => _call(context),
      child: Container(
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

    // Registra el evento de contacto en Firestore para notificar al dueño del perfil
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
          const SnackBar(content: Text('No se pudo abrir WhatsApp.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: () => _openWhatsApp(context, ref),
        icon: const FaIcon(FontAwesomeIcons.whatsapp, size: 20),
        label: const Text(
          'Contactar por WhatsApp',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF25D366),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
    );
  }
}
