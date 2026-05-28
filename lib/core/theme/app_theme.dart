import 'package:flutter/material.dart';

const kBackgroundColor = Color(0xFF091728);
const kSurfaceColor = Color(0xFF0C1F38);
const kAccentBlue = Color(0xFF4FA8DE);
const kTextPrimary = Colors.white;
const kTextSecondary = Color(0xFF8899AA);

const kCategoryColors = {
  'EMPRENDIMIENTO': Color(0xFFFFB74D),
  'SERVICIO': Color(0xFF4FC3F7),
  'EMPRESA': Color(0xFFCE93D8),
  'ARTE': Color(0xFF80CBC4),
};

final appTheme = ThemeData(
  scaffoldBackgroundColor: kBackgroundColor,
  colorScheme: const ColorScheme.dark(
    surface: kSurfaceColor,
    primary: kAccentBlue,
  ),
  fontFamily: 'Roboto',
);
