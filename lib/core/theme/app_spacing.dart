/// Spacing tokens — use these for padding, margin, gap, and SizedBox sizes.
/// Based on a 4pt base grid.
abstract final class AppSpacing {
  static const double x1  =  4;
  static const double x2  =  8;
  static const double x3  = 12;
  static const double x4  = 16;
  static const double x5  = 20;
  static const double x6  = 24;
  static const double x7  = 28;
  static const double x8  = 32;
  static const double x10 = 40;
  static const double x12 = 48;
  static const double x14 = 56;

  // ── Semantic aliases ───────────────────────────────────────────────────────
  static const double pagePadding     = x4;   // horizontal page margin
  static const double cardPadding     = x4;   // inner padding of cards
  static const double sectionGap      = x6;   // gap between sections
  static const double itemGap         = x3;   // gap between list items
  static const double inputPaddingH   = x4;
  static const double inputPaddingV   = 14;
  static const double buttonHeight    = 52;
  static const double iconButtonSize  = 36;
  static const double avatarMd        = 72;
  static const double avatarLg        = 90;
}
