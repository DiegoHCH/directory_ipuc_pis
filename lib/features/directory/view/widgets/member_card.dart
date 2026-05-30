import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../model/member.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

class MemberCard extends StatelessWidget {
  final Member member;
  final bool isMe;

  const MemberCard({super.key, required this.member, this.isMe = false});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final categoryColor = kCategoryColors[member.category.tag] ?? kAccentBlue;

    return GestureDetector(
      onTap: () => context.push(isMe ? '/my-profile' : '/member',
          extra: isMe ? null : member),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: isMe
              ? Border.all(color: kAccentBlue.withValues(alpha: 0.6))
              : null,
        ),
        child: Row(
          children: [
            _Avatar(initials: member.initials, backgroundColor: colors.background),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          member.name,
                          style: TextStyle(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: kAccentBlue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'TÚ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    member.description,
                    style: TextStyle(
                        color: colors.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Row(
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
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        member.phone,
                        style: TextStyle(
                            color: colors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right,
                color: context.colors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String initials;
  final Color backgroundColor;

  const _Avatar({required this.initials, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kAccentBlue.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: kAccentBlue,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

