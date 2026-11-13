import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Pro 9 Studio — Dark Theme with exact brand colors.
class Pro9Theme {
  Pro9Theme._();

  // ── Brand Colors ──────────────────────────────────────────────────────────
  static const Color scaffoldBg = Color(0xFF070B14); // Deep Obsidian Dark
  static const Color cardBg = Color(0xFF0F172A); // Dark Slate Blue
  static const Color cardBorder = Color(0xFF1E293B); // Subtle border
  static const Color primaryBlue = Color(0xFF0066FF); // Electric Royal Blue
  static const Color glowCyan = Color(0xFF00E5FF); // Neon Cyan
  static const Color glowBlue = Color(0xFF006AFF); // Outer glow for text
  static const Color gradientTop = Color(0xFF78F6FF); // Text gradient top
  static const Color gradientBottom = Color(0xFF1296FF); // Text gradient bottom
  static const Color frameBorderStart = Color(0xFF0052FF);
  static const Color frameBorderEnd = Color(0xFF00E5FF);

  // ── Surface / Text ────────────────────────────────────────────────────────
  static const Color surfaceLight = Color(0xFF1E293B);
  static const Color textPrimary = Color(0xFFE2E8F0);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF22C55E);

  /// The full dark [ThemeData] used by the app.
  static ThemeData get darkTheme {
    final baseText = GoogleFonts.montserratTextTheme(
      ThemeData.dark().textTheme,
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: scaffoldBg,
      primaryColor: primaryBlue,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: glowCyan,
        surface: cardBg,
        error: errorRed,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: textPrimary,
        onError: Colors.white,
      ),
      cardColor: cardBg,
      dividerColor: cardBorder,
      textTheme: baseText.apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cardBg,
        foregroundColor: textPrimary,
        elevation: 0,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scaffoldBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryBlue,
        inactiveTrackColor: cardBorder,
        thumbColor: glowCyan,
        overlayColor: glowCyan.withValues(alpha: 0.15),
        trackHeight: 4,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return glowCyan;
          return textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryBlue.withValues(alpha: 0.5);
          }
          return cardBorder;
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardBg,
        selectedColor: primaryBlue,
        labelStyle: GoogleFonts.montserrat(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        side: const BorderSide(color: cardBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: cardBorder),
        ),
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: surfaceLight,
          borderRadius: BorderRadius.circular(6),
        ),
        textStyle: const TextStyle(color: textPrimary, fontSize: 12),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(textMuted.withValues(alpha: 0.4)),
        radius: const Radius.circular(4),
      ),
    );
  }
}

