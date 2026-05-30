import 'package:flutter/material.dart';
import 'app_colors.dart';

const kAccentBlue = Color(0xFF4FA8DE);
const kCategoryColors = {
  'EMPRENDIMIENTO': Color(0xFFFFB74D),
  'SERVICIO': Color(0xFF4FC3F7),
  'EMPRESA': Color(0xFFCE93D8),
  'ARTE': Color(0xFF80CBC4),
};

final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.dark.background,
  colorScheme: ColorScheme.fromSeed(
    seedColor: kAccentBlue,
    brightness: Brightness.dark,
  ).copyWith(surface: AppColors.dark.surface),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    shape: CircleBorder(),
  ),
  extensions: const [AppColors.dark],
);

final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.light.background,
  colorScheme: ColorScheme.fromSeed(
    seedColor: kAccentBlue,
    brightness: Brightness.light,
  ).copyWith(surface: AppColors.light.surface),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    shape: CircleBorder(),
  ),
  extensions: const [AppColors.light],
);
