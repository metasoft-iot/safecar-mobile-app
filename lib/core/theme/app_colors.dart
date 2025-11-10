import 'package:flutter/material.dart';

/// Paleta de colores básica e indispensable para SafeCar Mobile App
/// 
/// Esta clase proporciona los colores esenciales para la aplicación,
/// siguiendo los principios de Clean Architecture y Material Design 3
class AppColors {
  AppColors._(); // Constructor privado para prevenir instanciación

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORES CORPORATIVOS PRINCIPALES - SAFECAR
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Púrpura corporativo principal de SafeCar (#5B67CA)
  static const Color primary = Color(0xFF5B67CA);
  
  /// Celeste tecnológico secundario (#3B82F6)
  static const Color secondary = Color(0xFF3B82F6);

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORES DE FONDO
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Fondo principal de la aplicación (#ECEBEB)
  static const Color background = Color(0xFFECEBEB);
  
  /// Fondo de tarjetas (#F8FBFF)
  static const Color cardBackground = Color(0xFFF8FBFF);

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORES DE ESTADO
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Color de éxito (#28A745)
  static const Color success = Color(0xFF28A745);
  
  /// Color de error coral (#EF4444)
  static const Color error = Color(0xFFEF4444);
  
  /// Color de advertencia (#FFC107)
  static const Color warning = Color(0xFFFFC107);
  
  /// Color de información (#17A2B8)
  static const Color info = Color(0xFF17A2B8);

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORES DE TEXTO
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Texto principal (#363636)
  static const Color textPrimary = Color(0xFF363636);
  
  /// Texto secundario (#6C757D)
  static const Color textSecondary = Color(0xFF6C757D);
  
  /// Texto deshabilitado (#9CA3AF)
  static const Color textDisabled = Color(0xFF9CA3AF);

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORES BÁSICOS
  // ═══════════════════════════════════════════════════════════════════════════
  
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORES INTERACTIVOS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Estado hover (#1E2A8A)
  static const Color hover = Color(0xFF1E2A8A);
  
  /// Estado focus (#4338CA)
  static const Color focus = Color(0xFF4338CA);
  
  /// Estado activo (#1D4ED8)
  static const Color active = Color(0xFF1D4ED8);

  // ═══════════════════════════════════════════════════════════════════════════
  // COLORES ESPECÍFICOS DE SAFECAR
  // ═══════════════════════════════════════════════════════════════════════════
  
  // Estados de citas (appointments)
  static const Color appointmentPending = warning;
  static const Color appointmentConfirmed = success;
  static const Color appointmentInProgress = info;
  static const Color appointmentCompleted = Color(0xFF00C851);
  static const Color appointmentCancelled = error;
  
  // Estados de vehículos
  static const Color vehicleActive = success;
  static const Color vehicleInMaintenance = warning;
  static const Color vehicleInactive = Color(0xFF9E9E9E);

  // ═══════════════════════════════════════════════════════════════════════════
  // MÉTODOS UTILITARIOS
  // ═══════════════════════════════════════════════════════════════════════════
  
  /// Obtiene el color apropiado para un estado de cita
  static Color getAppointmentStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return appointmentPending;
      case 'confirmed':
        return appointmentConfirmed;
      case 'in_progress':
      case 'inprogress':
        return appointmentInProgress;
      case 'completed':
        return appointmentCompleted;
      case 'cancelled':
        return appointmentCancelled;
      default:
        return primary;
    }
  }

  /// Obtiene el color para un estado de vehículo
  static Color getVehicleStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'available':
        return vehicleActive;
      case 'maintenance':
      case 'in_maintenance':
        return vehicleInMaintenance;
      case 'inactive':
      case 'disabled':
        return vehicleInactive;
      default:
        return primary;
    }
  }
  
  /// Obtiene el color apropiado para un estado genérico
  static Color getStateColor(String state) {
    switch (state.toLowerCase()) {
      case 'success':
      case 'completed':
        return success;
      case 'error':
      case 'failed':
        return error;
      case 'warning':
      case 'pending':
        return warning;
      case 'info':
      case 'information':
        return info;
      default:
        return primary;
    }
  }
}