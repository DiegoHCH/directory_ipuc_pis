import 'package:flutter/material.dart';
import 'app_colors.dart';

// Constantes que no cambian entre temas
const kAccentBlue = Color(0xFF4FA8DE);
const kCategoryColors = {
  'EMPRENDIMIENTO': Color(0xFFFFB74D),
  'SERVICIO': Color(0xFF4FC3F7),
  'EMPRESA': Color(0xFFCE93D8),
  'ARTE': Color(0xFF80CBC4),
};

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.dark.background,
  colorScheme: ColorScheme.dark(
    surface: AppColors.dark.surface,
    primary: kAccentBlue,
  ),
  extensions: const [AppColors.dark],
);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.light.background,
  colorScheme: ColorScheme.light(
    surface: AppColors.light.surface,
    primary: kAccentBlue,
  ),
  extensions: const [AppColors.light],
);
