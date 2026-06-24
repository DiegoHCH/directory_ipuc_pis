import 'package:flutter/material.dart';

/// Typography tokens — font sizes, weights, line heights, and letter spacing.
/// Use the TextStyle getters to compose styles; pair with AppColors for color.
abstract final class AppTypography {
  static const String fontFamily = 'MyriadPro';

  // ── Font sizes ──────────────────────────────────────────────────────────────
  static const double sizeXs   = 11;
  static const double sizeSm   = 12;
  static const double sizeMd   = 13;
  static const double sizeBase = 14;
  static const double sizeLg   = 15;
  static const double sizeXl   = 16;
  static const double size2xl  = 20;
  static const double size3xl  = 22;
  static const double size4xl  = 28;

  // ── Font weights ────────────────────────────────────────────────────────────
  static const FontWeight thin      = FontWeight.w300;
  static const FontWeight regular   = FontWeight.w400;
  static const FontWeight medium    = FontWeight.w500;
  static const FontWeight semibold  = FontWeight.w600;
  static const FontWeight bold      = FontWeight.w700;
  static const FontWeight extrabold = FontWeight.w800;

  // ── Line heights ────────────────────────────────────────────────────────────
  static const double lineHeightTight   = 1.1;
  static const double lineHeightSnug    = 1.4;
  static const double lineHeightNormal  = 1.5;
  static const double lineHeightRelaxed = 1.6;

  // ── Letter spacing ──────────────────────────────────────────────────────────
  static const double trackingTight  = 0.5;
  static const double trackingNormal = 0.8;
  static const double trackingWide   = 1.2;
  static const double trackingWider  = 1.4;

  // ── Semantic text styles (colorless — apply color at usage site) ────────────
  static const TextStyle displayLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: size4xl,
    fontWeight: extrabold,
    height: lineHeightTight,
  );

  static const TextStyle headingLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: size3xl,
    fontWeight: extrabold,
  );

  static const TextStyle headingMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: size2xl,
    fontWeight: extrabold,
  );

  static const TextStyle titleLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeLg,
    fontWeight: semibold,
  );

  static const TextStyle titleMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeBase,
    fontWeight: medium,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeLg,
    fontWeight: regular,
    height: lineHeightNormal,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeBase,
    fontWeight: regular,
    height: lineHeightRelaxed,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeMd,
    fontWeight: regular,
    height: lineHeightNormal,
  );

  static const TextStyle labelLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeLg,
    fontWeight: semibold,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeSm,
    fontWeight: semibold,
    letterSpacing: trackingWide,
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeXs,
    fontWeight: bold,
    letterSpacing: trackingWider,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: sizeSm,
    fontWeight: regular,
    letterSpacing: trackingNormal,
  );
}
