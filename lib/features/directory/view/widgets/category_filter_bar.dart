import 'package:flutter/material.dart';
import '../../model/member.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class CategoryFilterBar extends StatelessWidget {
  final MemberCategory selected;
  final ValueChanged<MemberCategory> onSelected;

  const CategoryFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _categories = [
    MemberCategory.all,
    MemberCategory.empresa,
    MemberCategory.emprendimiento,
    MemberCategory.arte,
    MemberCategory.servicio,
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((cat) {
          final isActive = cat == selected;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.x2),
            child: GestureDetector(
              onTap: () => onSelected(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: AppSpacing.x2),
                decoration: BoxDecoration(
                  color: isActive ? colors.primary : colors.surface,
                  borderRadius: AppRadius.chip,
                  border: isActive
                      ? null
                      : Border.all(
                          color:
                              colors.textSecondary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  cat.label,
                  style: TextStyle(
                    color: isActive ? Colors.white : colors.textSecondary,
                    fontWeight: isActive
                        ? AppTypography.semibold
                        : AppTypography.regular,
                    fontSize: AppTypography.sizeMd,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
