import 'package:flutter/material.dart';
import '../services/cloudinary_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import '../../features/directory/model/member.dart';

/// Avatar de miembro que muestra foto de Cloudinary o iniciales como fallback.
///
/// [circle] = true → forma circular (perfiles).
/// [circle] = false → rectángulo redondeado (tarjetas de directorio).
class MemberAvatar extends StatelessWidget {
  final Member member;
  final double size;
  final bool circle;

  const MemberAvatar({
    super.key,
    required this.member,
    this.size = 46,
    this.circle = false,
  });

  @override
  Widget build(BuildContext context) {
    final photo = member.photoUrl;
    final radius = circle ? size / 2 : AppRadius.lg;
    final colors = context.colors;

    final fallback = _Initials(
      initials: member.initials,
      size: size,
      radius: radius,
    );

    if (photo == null || photo.isEmpty) return fallback;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Image.network(
          cloudinaryThumb(photo, size: (size * 2).round()),
          width: size,
          height: size,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : fallback,
          errorBuilder: (context, err, stack) => fallback,
        ),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  final String initials;
  final double size;
  final double radius;

  const _Initials({
    required this.initials,
    required this.size,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: colors.primary,
            fontWeight: AppTypography.bold,
            fontSize: size * 0.32,
          ),
        ),
      ),
    );
  }
}
