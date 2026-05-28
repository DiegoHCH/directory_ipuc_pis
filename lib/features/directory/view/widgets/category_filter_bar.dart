import 'package:flutter/material.dart';
import '../../model/member.dart';
import '../../../../core/theme/app_theme.dart';

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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((cat) {
          final isActive = cat == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => onSelected(cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? kAccentBlue : kSurfaceColor,
                  borderRadius: BorderRadius.circular(20),
                  border: isActive
                      ? null
                      : Border.all(color: kTextSecondary.withValues(alpha: 0.3)),
                ),
                child: Text(
                  cat.label,
                  style: TextStyle(
                    color: isActive ? Colors.white : kTextSecondary,
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 13,
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
