import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_primitives.dart';
import 'app_typography.dart';

// Kept for backward compatibility — prefer context.colors.primary in new code.
const kAccentBlue = AppPrimitives.brand400;

// Kept for backward compatibility — prefer context.colors.categoryColor(tag) in new code.
const kCategoryColors = {
  'EMPRENDIMIENTO': AppPrimitives.amber300,
  'SERVICIO':       AppPrimitives.lightBlue300,
  'EMPRESA':        AppPrimitives.purple200,
  'ARTE':           AppPrimitives.teal200,
};

final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  fontFamily: AppTypography.fontFamily,
  scaffoldBackgroundColor: AppColors.dark.background,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppPrimitives.brand400,
    brightness: Brightness.dark,
  ).copyWith(
    surface: AppColors.dark.surface,
    error: AppColors.dark.error,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    shape: CircleBorder(),
  ),
  extensions: const [AppColors.dark],
);

final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  fontFamily: AppTypography.fontFamily,
  scaffoldBackgroundColor: AppColors.light.background,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppPrimitives.brand400,
    brightness: Brightness.light,
  ).copyWith(
    surface: AppColors.light.surface,
    error: AppColors.light.error,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    shape: CircleBorder(),
  ),
  extensions: const [AppColors.light],
);
