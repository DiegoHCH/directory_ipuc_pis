import 'package:flutter/material.dart';
import 'app_primitives.dart';

/// Layer 2 — Semantic color tokens.
/// Each token expresses intent (what it's for), not appearance (what it looks like).
/// Always consume these via context.colors — never hard-code hex values in widgets.
class AppColors extends ThemeExtension<AppColors> {
  // ── Backgrounds ────────────────────────────────────────────────────────────
  final Color background;      // page / scaffold background
  final Color surface;         // cards, sheets, inputs
  final Color surfaceVariant;  // slightly elevated surface (e.g. nested cards)

  // ── Text ───────────────────────────────────────────────────────────────────
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color textOnPrimary;   // text placed on top of primary color

  // ── Brand / Primary ────────────────────────────────────────────────────────
  final Color primary;         // main accent — buttons, links, highlights
  final Color primaryMuted;    // low-opacity primary for backgrounds / icons

  // ── Status ─────────────────────────────────────────────────────────────────
  final Color error;
  final Color errorMuted;
  final Color success;
  final Color successMuted;

  // ── Utility ────────────────────────────────────────────────────────────────
  final Color border;          // dividers, input borders
  final Color whatsapp;        // WhatsApp brand color

  // ── Categories ─────────────────────────────────────────────────────────────
  final Color categoryEmprendimiento;
  final Color categoryServicio;
  final Color categoryEmpresa;
  final Color categoryArte;

  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.textOnPrimary,
    required this.primary,
    required this.primaryMuted,
    required this.error,
    required this.errorMuted,
    required this.success,
    required this.successMuted,
    required this.border,
    required this.whatsapp,
    required this.categoryEmprendimiento,
    required this.categoryServicio,
    required this.categoryEmpresa,
    required this.categoryArte,
  });

  // ── Dark theme ─────────────────────────────────────────────────────────────
  static const dark = AppColors(
    background:              AppPrimitives.neutral900,
    surface:                 AppPrimitives.neutral800,
    surfaceVariant:          Color(0xFF112236),
    textPrimary:             AppPrimitives.neutral0,
    textSecondary:           AppPrimitives.neutral500,
    textDisabled:            Color(0xFF4A5A6A),
    textOnPrimary:           AppPrimitives.neutral0,
    primary:                 AppPrimitives.brand400,
    primaryMuted:            Color(0x1F4FA8DE), // brand400 @ 12%
    error:                   AppPrimitives.red400,
    errorMuted:              Color(0x1FEF5350), // red400 @ 12%
    success:                 AppPrimitives.green400,
    successMuted:            Color(0x1F4CAF50),
    border:                  Color(0x1FFFFFFF), // white @ 12%
    whatsapp:                AppPrimitives.green500,
    categoryEmprendimiento:  AppPrimitives.amber300,
    categoryServicio:        AppPrimitives.lightBlue300,
    categoryEmpresa:         AppPrimitives.purple200,
    categoryArte:            AppPrimitives.teal200,
  );

  // ── Light theme ────────────────────────────────────────────────────────────
  static const light = AppColors(
    background:              AppPrimitives.neutral50,
    surface:                 AppPrimitives.neutral0,
    surfaceVariant:          Color(0xFFE4EAF4),
    textPrimary:             AppPrimitives.neutral850,
    textSecondary:           AppPrimitives.neutral400,
    textDisabled:            Color(0xFFB0BEC5),
    textOnPrimary:           AppPrimitives.neutral0,
    primary:                 AppPrimitives.brand400,
    primaryMuted:            Color(0x1F4FA8DE),
    error:                   AppPrimitives.red400,
    errorMuted:              Color(0x1FEF5350),
    success:                 AppPrimitives.green400,
    successMuted:            Color(0x1F4CAF50),
    border:                  Color(0x1F000000), // black @ 12%
    whatsapp:                AppPrimitives.green500,
    categoryEmprendimiento:  AppPrimitives.amber300,
    categoryServicio:        AppPrimitives.lightBlue300,
    categoryEmpresa:         AppPrimitives.purple200,
    categoryArte:            AppPrimitives.teal200,
  );

  // ── Map by category tag ────────────────────────────────────────────────────
  Color categoryColor(String tag) => switch (tag) {
        'EMPRENDIMIENTO' => categoryEmprendimiento,
        'SERVICIO'       => categoryServicio,
        'EMPRESA'        => categoryEmpresa,
        'ARTE'           => categoryArte,
        _                => primary,
      };

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? textOnPrimary,
    Color? primary,
    Color? primaryMuted,
    Color? error,
    Color? errorMuted,
    Color? success,
    Color? successMuted,
    Color? border,
    Color? whatsapp,
    Color? categoryEmprendimiento,
    Color? categoryServicio,
    Color? categoryEmpresa,
    Color? categoryArte,
  }) =>
      AppColors(
        background:             background             ?? this.background,
        surface:                surface                ?? this.surface,
        surfaceVariant:         surfaceVariant         ?? this.surfaceVariant,
        textPrimary:            textPrimary            ?? this.textPrimary,
        textSecondary:          textSecondary          ?? this.textSecondary,
        textDisabled:           textDisabled           ?? this.textDisabled,
        textOnPrimary:          textOnPrimary          ?? this.textOnPrimary,
        primary:                primary                ?? this.primary,
        primaryMuted:           primaryMuted           ?? this.primaryMuted,
        error:                  error                  ?? this.error,
        errorMuted:             errorMuted             ?? this.errorMuted,
        success:                success                ?? this.success,
        successMuted:           successMuted           ?? this.successMuted,
        border:                 border                 ?? this.border,
        whatsapp:               whatsapp               ?? this.whatsapp,
        categoryEmprendimiento: categoryEmprendimiento ?? this.categoryEmprendimiento,
        categoryServicio:       categoryServicio       ?? this.categoryServicio,
        categoryEmpresa:        categoryEmpresa        ?? this.categoryEmpresa,
        categoryArte:           categoryArte           ?? this.categoryArte,
      );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      background:             Color.lerp(background,             other.background,             t)!,
      surface:                Color.lerp(surface,                other.surface,                t)!,
      surfaceVariant:         Color.lerp(surfaceVariant,         other.surfaceVariant,         t)!,
      textPrimary:            Color.lerp(textPrimary,            other.textPrimary,            t)!,
      textSecondary:          Color.lerp(textSecondary,          other.textSecondary,          t)!,
      textDisabled:           Color.lerp(textDisabled,           other.textDisabled,           t)!,
      textOnPrimary:          Color.lerp(textOnPrimary,          other.textOnPrimary,          t)!,
      primary:                Color.lerp(primary,                other.primary,                t)!,
      primaryMuted:           Color.lerp(primaryMuted,           other.primaryMuted,           t)!,
      error:                  Color.lerp(error,                  other.error,                  t)!,
      errorMuted:             Color.lerp(errorMuted,             other.errorMuted,             t)!,
      success:                Color.lerp(success,                other.success,                t)!,
      successMuted:           Color.lerp(successMuted,           other.successMuted,           t)!,
      border:                 Color.lerp(border,                 other.border,                 t)!,
      whatsapp:               Color.lerp(whatsapp,               other.whatsapp,               t)!,
      categoryEmprendimiento: Color.lerp(categoryEmprendimiento, other.categoryEmprendimiento, t)!,
      categoryServicio:       Color.lerp(categoryServicio,       other.categoryServicio,       t)!,
      categoryEmpresa:        Color.lerp(categoryEmpresa,        other.categoryEmpresa,        t)!,
      categoryArte:           Color.lerp(categoryArte,           other.categoryArte,           t)!,
    );
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
