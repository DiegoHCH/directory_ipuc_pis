import 'package:flutter/material.dart';

/// Layer 1 — Raw color palette.
/// No semantics here, just named values. Use AppColors for semantic tokens.
abstract final class AppPrimitives {
  // ── Brand (blue scale) ─────────────────────────────────────────────────────
  static const brand50  = Color(0xFFE8F4FB);
  static const brand100 = Color(0xFFB9DDEF);
  static const brand200 = Color(0xFF8AC6E3);
  static const brand300 = Color(0xFF5BAFD7);
  static const brand400 = Color(0xFF4FA8DE); // primary accent
  static const brand500 = Color(0xFF3A8FBF);
  static const brand600 = Color(0xFF2870A0);

  // ── Neutral (dark navy scale) ──────────────────────────────────────────────
  static const neutral900 = Color(0xFF091728); // darkest background
  static const neutral850 = Color(0xFF0A1628);
  static const neutral800 = Color(0xFF0C1F38); // dark surface
  static const neutral500 = Color(0xFF8899AA); // dark text secondary
  static const neutral400 = Color(0xFF6B7D8F); // light text secondary
  static const neutral50  = Color(0xFFF0F3FA); // light background
  static const neutral0   = Color(0xFFFFFFFF);

  // ── Status ─────────────────────────────────────────────────────────────────
  static const red400   = Color(0xFFEF5350); // error / danger
  static const green400 = Color(0xFF4CAF50); // success
  static const green500 = Color(0xFF25D366); // whatsapp

  // ── Category ───────────────────────────────────────────────────────────────
  static const amber300     = Color(0xFFFFB74D); // EMPRENDIMIENTO
  static const lightBlue300 = Color(0xFF4FC3F7); // SERVICIO
  static const purple200    = Color(0xFFCE93D8); // EMPRESA
  static const teal200      = Color(0xFF80CBC4); // ARTE
}
