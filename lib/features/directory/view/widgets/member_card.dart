import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../model/member.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/member_avatar.dart';

class MemberCard extends StatelessWidget {
  final Member member;
  final bool isMe;

  const MemberCard({super.key, required this.member, this.isMe = false});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final categoryColor = colors.categoryColor(member.category.tag);

    return GestureDetector(
      onTap: () => context.push(isMe ? '/my-profile' : '/member',
          extra: isMe ? null : member),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: AppRadius.button,
          border: isMe
              ? Border.all(color: colors.primary.withValues(alpha: 0.6))
              : null,
        ),
        child: Row(
          children: [
            MemberAvatar(member: member, size: 46),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          member.name,
                          style: AppTypography.titleLg.copyWith(
                            color: colors.textPrimary,
                            fontWeight: AppTypography.semibold,
                          ),
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: AppRadius.brSm,
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
                  if (member.description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      member.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: AppTypography.sizeMd),
                    ),
                  ],
                  if (member.category != MemberCategory.buscador) ...[
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
                            fontSize: AppTypography.sizeXs,
                            fontWeight: AppTypography.semibold,
                            letterSpacing: AppTypography.trackingTight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x1),
            Icon(Icons.chevron_right,
                color: context.colors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
