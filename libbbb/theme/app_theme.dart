import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Warna & tipografi diambil dari DESIGN.md wireframe "Lisaps"
/// (gaya wireframe arsitektural: hitam-putih, aksen biru kobalt tipis).
class AppColors {
  static const ink = Color(0xFF121316); // primary
  static const graphite = Color(0xFF5E636E); // secondary
  static const cobalt = Color(0xFF2B6CB0); // tertiary / accent
  static const draftingSlate = Color(0xFF8C919E); // neutral / placeholder
  static const canvas = Color(0xFFFAFAFC); // background
  static const card = Color(0xFFFFFFFF);
  static const chip = Color(0xFFF0F1F4);
  static const hairline = Color(0xFFE2E4E9);
  static const error = Color(0xFFBA1A1A);
  static const priorityHighBg = Color(0xFFFFDAD6);
  static const priorityHighText = Color(0xFF93000A);
  static const priorityMedBg = Color(0xFFE9EEFC);
  static const priorityMedText = Color(0xFF46464B);
  static const priorityLowBg = Color(0xFFF0F1F4);
  static const priorityLowText = Color(0xFF5E636E);
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.canvas,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.ink,
        onPrimary: Colors.white,
        secondary: AppColors.cobalt,
        surface: AppColors.card,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.geistTextTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.canvas,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.ink,
      ),
      dividerColor: AppColors.hairline,
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: AppColors.draftingSlate, width: 1.5),
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.ink
              : Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          textStyle: GoogleFonts.geist(fontWeight: FontWeight.w500, fontSize: 15),
        ),
      ),
    );
  }

  /// Font monospace untuk metadata (JetBrains Mono di wireframe)
  static TextStyle mono({
    double fontSize = 11,
    FontWeight fontWeight = FontWeight.w500,
    Color color = AppColors.graphite,
    double letterSpacing = 0.4,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }
}
