import 'package:flutter/material.dart';
import '../../../directory/model/member.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

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

  String _catLabel(BuildContext context, MemberCategory cat) => switch (cat) {
        MemberCategory.all           => context.l10n.catAll,
        MemberCategory.empresa       => context.l10n.catEmpresa,
        MemberCategory.emprendimiento => context.l10n.catEmprendimiento,
        MemberCategory.arte          => context.l10n.catArte,
        MemberCategory.servicio      => context.l10n.catServicio,
        MemberCategory.buscador      => cat.label,
      };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 3.4,
      children: _options.map((cat) {
        final isSelected = cat == selected;
        final dotColor = colors.categoryColor(cat.tag);
        return GestureDetector(
          onTap: () => onSelected(cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: isSelected ? colors.primary : colors.surface,
              borderRadius: AppRadius.input,
              border: isSelected
                  ? null
                  : Border.all(
                      color: colors.textSecondary.withValues(alpha: 0.25)),
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
                  _catLabel(context, cat),
                  style: TextStyle(
                    color: isSelected ? Colors.white : colors.textSecondary,
                    fontWeight: isSelected
                        ? AppTypography.semibold
                        : AppTypography.regular,
                    fontSize: AppTypography.sizeBase,
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
