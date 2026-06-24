import 'package:flutter/material.dart';

/// Radius tokens — use these for BorderRadius across the app.
abstract final class AppRadius {
  static const double xs  =  4;
  static const double sm  =  6;
  static const double md  = 10;
  static const double lg  = 12;
  static const double xl  = 14;
  static const double x2l = 16;
  static const double x3l = 20;
  static const double x4l = 24;
  static const double full = 999; // pill / circle

  // ── BorderRadius shortcuts ──────────────────────────────────────────────────
  static const BorderRadius brXs  = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius brSm  = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd  = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg  = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl  = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius brX2l = BorderRadius.all(Radius.circular(x2l));
  static const BorderRadius brX3l = BorderRadius.all(Radius.circular(x3l));
  static const BorderRadius brX4l = BorderRadius.all(Radius.circular(x4l));
  static const BorderRadius brFull = BorderRadius.all(Radius.circular(full));

  // ── Semantic aliases ────────────────────────────────────────────────────────
  static const BorderRadius card        = brX2l; // 16 — cards, sheets
  static const BorderRadius input       = brLg;  // 12 — text fields
  static const BorderRadius button      = brXl;  // 14 — buttons
  static const BorderRadius chip        = brX3l; // 20 — category chips
  static const BorderRadius iconButton  = brMd;  // 10 — icon buttons
  static const BorderRadius dialog      = brX4l; // 24 — dialogs / bottom sheets
  static const BorderRadius badge       = brFull;
}
