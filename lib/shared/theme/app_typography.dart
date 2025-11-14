import 'package:flutter/material.dart';

/// Sistema de tipografías para SafeCar Mobile App basado en Material Design 3
///
/// Esta clase proporciona un TextTheme completo usando fuentes del sistema
/// con una jerarquía visual clara y consistente siguiendo Clean Architecture
class AppTypography {
  AppTypography._(); // Constructor privado para prevenir instanciación

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT THEME PRINCIPAL - LISTO PARA USAR EN THEMEDATA
  // ═══════════════════════════════════════════════════════════════════════════

  /// TextTheme completo para usar directamente en ThemeData
  ///
  /// Uso:
  /// ```dart
  /// theme: ThemeData(
  ///   textTheme: AppTypography.textTheme,
  /// )
  /// ```
  static const TextTheme textTheme = TextTheme(
    // ═══════════════════════════════════════════════════════════════════════════
    // DISPLAY STYLES - Para elementos hero y títulos principales
    // ═══════════════════════════════════════════════════════════════════════════

    /// Títulos principales de pantalla (40px, Bold)
    displayLarge: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w700, // Bold
      height: 1.2,
      letterSpacing: -0.5,
    ),

    displayMedium: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600, // SemiBold
      height: 1.2,
      letterSpacing: -0.25,
    ),

    displaySmall: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600, // SemiBold
      height: 1.25,
      letterSpacing: 0,
    ),

    // ═══════════════════════════════════════════════════════════════════════════
    // HEADLINE STYLES - Para encabezados de secciones
    // ═══════════════════════════════════════════════════════════════════════════
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600, // SemiBold
      height: 1.3,
      letterSpacing: -0.25,
    ),

    /// Encabezados principales (24px, SemiBold)
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600, // SemiBold
      height: 1.3,
      letterSpacing: 0,
    ),

    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600, // SemiBold
      height: 1.3,
      letterSpacing: 0,
    ),

    // ═══════════════════════════════════════════════════════════════════════════
    // TITLE STYLES - Para títulos de componentes y tarjetas
    // ═══════════════════════════════════════════════════════════════════════════

    /// Títulos de tarjetas y componentes (20px, Medium)
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500, // Medium
      height: 1.3,
      letterSpacing: 0.15,
    ),

    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500, // Medium
      height: 1.3,
      letterSpacing: 0.15,
    ),

    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500, // Medium
      height: 1.4,
      letterSpacing: 0.1,
    ),

    // ═══════════════════════════════════════════════════════════════════════════
    // BODY STYLES - Para contenido de texto principal
    // ═══════════════════════════════════════════════════════════════════════════

    /// Texto de cuerpo principal (16px, Regular)
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400, // Regular
      height: 1.5,
      letterSpacing: 0.5,
    ),

    /// Texto de cuerpo secundario (14px, Regular)
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400, // Regular
      height: 1.5,
      letterSpacing: 0.25,
    ),

    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400, // Regular
      height: 1.4,
      letterSpacing: 0.4,
    ),

    // ═══════════════════════════════════════════════════════════════════════════
    // LABEL STYLES - Para etiquetas, botones y elementos interactivos
    // ═══════════════════════════════════════════════════════════════════════════
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500, // Medium
      height: 1.4,
      letterSpacing: 0.1,
    ),

    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500, // Medium
      height: 1.4,
      letterSpacing: 0.5,
    ),

    /// Etiquetas pequeñas (12px, Medium)
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500, // Medium
      height: 1.4,
      letterSpacing: 0.5,
    ),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // ESTILOS ADICIONALES ESPECÍFICOS DE SAFECAR
  // ═══════════════════════════════════════════════════════════════════════════

  /// Estilo para destacar información importante
  static const TextStyle highlight = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700, // Bold
    height: 1.2,
    letterSpacing: 0,
  );

  /// Estilo para placas de vehículos (monospace)
  static const TextStyle vehiclePlate = TextStyle(
    fontFamily: 'monospace',
    fontSize: 16,
    fontWeight: FontWeight.w700, // Bold
    height: 1.3,
    letterSpacing: 2.0,
  );

  /// Estilo para números destacados (IDs, contadores)
  static const TextStyle numberHighlight = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.3,
    letterSpacing: 0.5,
  );

  /// Estilo para badges de estado
  static const TextStyle statusBadge = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.2,
    letterSpacing: 0.5,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // MÉTODOS UTILITARIOS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Aplica un color específico a cualquier estilo del textTheme
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Modifica el peso de fuente de un estilo existente
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Aplica decoración de texto (subrayado, tachado, etc.)
  static TextStyle withDecoration(TextStyle style, TextDecoration decoration) {
    return style.copyWith(decoration: decoration);
  }
}