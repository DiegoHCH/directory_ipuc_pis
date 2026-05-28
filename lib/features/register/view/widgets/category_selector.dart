import 'package:flutter/material.dart';
import '../../../directory/model/member.dart';
import '../../../../core/theme/app_theme.dart';

class CategorySelector extends StatelessWidget {
  final MemberCategory? selected;
  final ValueChanged<MemberCategory> onSelected;

  const CategorySelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const _options = [
    MemberCategory.empresa,
    MemberCategory.emprendimiento,
    MemberCategory.arte,
    MemberCategory.servicio,
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 3.4,
      children: _options.map((cat) {
        final isSelected = cat == selected;
        final dotColor = kCategoryColors[cat.tag] ?? kAccentBlue;
        return GestureDetector(
          onTap: () => onSelected(cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: isSelected ? kAccentBlue : kSurfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? null
                  : Border.all(
                      color: kTextSecondary.withValues(alpha: 0.25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  cat.label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : kTextSecondary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
