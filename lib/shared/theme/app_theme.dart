import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Tema principal de la aplicación SafeCar Mobile App
///
/// Configura el ThemeData de Material Design 3 usando AppColors y AppTypography
/// siguiendo los principios de Clean Architecture
class AppTheme {
  AppTheme._(); // Constructor privado

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORES PRINCIPALES - SAFECAR
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color primaryColor = AppColors.primary;
  static const Color secondaryColor = AppColors.secondary;
  static const Color backgroundColor = AppColors.background;
  static const Color cardBackgroundColor = AppColors.cardBackground;

  // Colores de texto
  static const Color textColor = AppColors.textPrimary;
  static const Color textSecondaryColor = AppColors.textSecondary;
  static const Color textDisabledColor = AppColors.textDisabled;

  // Colores de estado
  static const Color successColor = AppColors.success;
  static const Color errorColor = AppColors.error;
  static const Color warningColor = AppColors.warning;
  static const Color infoColor = AppColors.info;

  // ═══════════════════════════════════════════════════════════════════════════
  // TEMA CLARO
  // ═══════════════════════════════════════════════════════════════════════════

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // Esquema de colores
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        surface: AppColors.white,
        error: errorColor,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: textColor,
        onError: AppColors.white,
      ),

      // Tipografía
      textTheme: AppTypography.textTheme,

      // Tema del AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),

      // Tema de los botones elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: AppColors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Tema de las tarjetas
      cardTheme: CardThemeData(
        color: cardBackgroundColor,
        elevation: 2,
        shadowColor: AppColors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    );
  }
}
