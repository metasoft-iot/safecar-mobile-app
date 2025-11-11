import 'package:flutter/material.dart';

/// AppBar genérico para SafeCar Mobile App
/// 
/// ## Modos disponibles:
/// 
/// ### 1. Simple (solo título centrado)
/// ```dart
/// CustomAppBar.simple(
///   title: 'Home',
///   backgroundColor: AppColors.primary,
///   titleStyle: TextStyle(color: Colors.white),
/// )
/// ```
/// 
/// ### 2. Con botón de retroceso (icono + título centrado)
/// ```dart
/// CustomAppBar.withBackButton(
///   title: 'Details',
///   backgroundColor: AppColors.primary,
///   titleStyle: TextStyle(color: Colors.white),
///   onBackPressed: () => Navigator.pop(context), // Opcional
/// )
/// ```
/// 
/// ## Características:
/// - ✅ Título siempre centrado en ambos modos
/// - ✅ Icono de retroceso: `Icons.arrow_back_ios_new`
/// - ✅ Callback personalizado para el botón de retroceso
/// - ✅ Soporte para acciones adicionales (actions)
/// - ✅ Personalización completa de colores y estilos
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leadingIcon;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final double elevation;

  const CustomAppBar._({
    required this.title,
    this.leadingIcon,
    this.actions,
    this.backgroundColor,
    this.titleStyle,
    this.elevation = 0,
  });

  /// AppBar simple con solo título centrado
  /// 
  /// Ejemplo:
  /// ```dart
  /// CustomAppBar.simple(title: 'Home')
  /// ```
  factory CustomAppBar.simple({
    required String title,
    List<Widget>? actions,
    Color? backgroundColor,
    TextStyle? titleStyle,
    double elevation = 0,
  }) {
    return CustomAppBar._(
      title: title,
      actions: actions,
      backgroundColor: backgroundColor,
      titleStyle: titleStyle,
      elevation: elevation,
    );
  }

  /// AppBar con icono de retroceso + título centrado
  /// 
  /// Ejemplo:
  /// ```dart
  /// CustomAppBar.withBackButton(
  ///   title: 'Details',
  ///   onBackPressed: () => Navigator.pop(context),
  /// )
  /// ```
  factory CustomAppBar.withBackButton({
    required String title,
    VoidCallback? onBackPressed,
    List<Widget>? actions,
    Color? backgroundColor,
    TextStyle? titleStyle,
    double elevation = 0,
  }) {
    return CustomAppBar._(
      title: title,
      leadingIcon: _BackButton(onPressed: onBackPressed),
      actions: actions,
      backgroundColor: backgroundColor,
      titleStyle: titleStyle,
      elevation: elevation,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTitleStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurface,
    );

    return AppBar(
      title: Text(
        title,
        style: titleStyle ?? defaultTitleStyle,
      ),
      centerTitle: true,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      elevation: elevation,
      leading: leadingIcon,
      actions: actions,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Botón de retroceso privado
class _BackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _BackButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
      onPressed: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          Navigator.of(context).pop();
        }
      },
      tooltip: 'Atrás',
    );
  }
}
