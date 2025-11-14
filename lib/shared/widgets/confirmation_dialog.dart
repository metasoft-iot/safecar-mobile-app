import 'package:flutter/material.dart';
import 'package:safecar_mobile_app/shared/theme/app_colors.dart';

/// SafeCar Mobile App - Confirmation Dialog
/// Completely reusable and generic confirmation dialog for any action
/// 
/// Usage examples:
/// ```dart
/// // Delete confirmation
/// ConfirmationDialog.show(
///   context: context,
///   type: ConfirmationDialogType.delete,
///   title: 'Delete Item?',
///   message: 'This action cannot be undone.',
///   onConfirm: () => deleteItem(),
/// );
/// 
/// // Warning confirmation
/// ConfirmationDialog.show(
///   context: context,
///   type: ConfirmationDialogType.warning,
///   title: 'Are you sure?',
///   message: 'This will affect your settings.',
///   confirmText: 'Continue',
///   onConfirm: () => continueAction(),
/// );
/// 
/// // Custom confirmation
/// ConfirmationDialog.show(
///   context: context,
///   icon: Icons.check_circle_outline,
///   iconColor: Colors.green,
///   iconBackgroundColor: Colors.green.shade50,
///   confirmButtonColor: Colors.green,
///   title: 'Success!',
///   message: 'Operation completed.',
///   confirmText: 'OK',
///   showCancelButton: false,
///   onConfirm: () {},
/// );
/// ```
enum ConfirmationDialogType {
  delete,
  warning,
  info,
  success,
  custom,
}

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color confirmButtonColor;
  final bool showCancelButton;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    this.onCancel,
    this.icon = Icons.help_outline,
    this.iconBackgroundColor = const Color(0xFFE3F2FD),
    this.iconColor = Colors.blue,
    this.confirmButtonColor = AppColors.primary,
    this.showCancelButton = true,
  });

  /// Factory constructor for delete/cancel actions (red theme)
  factory ConfirmationDialog.delete({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool showCancelButton = true,
  }) {
    return ConfirmationDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      icon: Icons.delete_outline,
      iconBackgroundColor: const Color(0xFFFFE5E5),
      iconColor: Colors.red,
      confirmButtonColor: Colors.red,
      showCancelButton: showCancelButton,
    );
  }

  /// Factory constructor for warning actions (orange theme)
  factory ConfirmationDialog.warning({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool showCancelButton = true,
  }) {
    return ConfirmationDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      icon: Icons.warning_amber_outlined,
      iconBackgroundColor: const Color(0xFFFFF3E0),
      iconColor: Colors.orange,
      confirmButtonColor: Colors.orange,
      showCancelButton: showCancelButton,
    );
  }

  /// Factory constructor for info actions (blue theme)
  factory ConfirmationDialog.info({
    required String title,
    required String message,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool showCancelButton = true,
  }) {
    return ConfirmationDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      icon: Icons.info_outline,
      iconBackgroundColor: const Color(0xFFE3F2FD),
      iconColor: Colors.blue,
      confirmButtonColor: Colors.blue,
      showCancelButton: showCancelButton,
    );
  }

  /// Factory constructor for success actions (green theme)
  factory ConfirmationDialog.success({
    required String title,
    required String message,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool showCancelButton = false,
  }) {
    return ConfirmationDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      icon: Icons.check_circle_outline,
      iconBackgroundColor: const Color(0xFFE8F5E9),
      iconColor: Colors.green,
      confirmButtonColor: Colors.green,
      showCancelButton: showCancelButton,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Message
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: confirmButtonColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  confirmText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Cancel Button (conditional)
            if (showCancelButton) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onCancel?.call();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.background,
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    cancelText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Static method to show the dialog
  /// 
  /// Example:
  /// ```dart
  /// await ConfirmationDialog.show(
  ///   context: context,
  ///   type: ConfirmationDialogType.delete,
  ///   title: 'Delete Item?',
  ///   message: 'This action cannot be undone.',
  ///   onConfirm: () => print('Confirmed'),
  /// );
  /// ```
  static Future<void> show({
    required BuildContext context,
    ConfirmationDialogType? type,
    String? title,
    String? message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    IconData? icon,
    Color? iconColor,
    Color? iconBackgroundColor,
    Color? confirmButtonColor,
    bool? showCancelButton,
  }) {
    // Create dialog based on type or custom parameters
    late ConfirmationDialog dialog;

    if (type != null && title != null && message != null && onConfirm != null) {
      switch (type) {
        case ConfirmationDialogType.delete:
          dialog = ConfirmationDialog.delete(
            title: title,
            message: message,
            confirmText: confirmText ?? 'Confirm',
            cancelText: cancelText ?? 'Cancel',
            onConfirm: onConfirm,
            onCancel: onCancel,
            showCancelButton: showCancelButton ?? true,
          );
          break;
        case ConfirmationDialogType.warning:
          dialog = ConfirmationDialog.warning(
            title: title,
            message: message,
            confirmText: confirmText ?? 'Confirm',
            cancelText: cancelText ?? 'Cancel',
            onConfirm: onConfirm,
            onCancel: onCancel,
            showCancelButton: showCancelButton ?? true,
          );
          break;
        case ConfirmationDialogType.info:
          dialog = ConfirmationDialog.info(
            title: title,
            message: message,
            confirmText: confirmText ?? 'OK',
            cancelText: cancelText ?? 'Cancel',
            onConfirm: onConfirm,
            onCancel: onCancel,
            showCancelButton: showCancelButton ?? true,
          );
          break;
        case ConfirmationDialogType.success:
          dialog = ConfirmationDialog.success(
            title: title,
            message: message,
            confirmText: confirmText ?? 'OK',
            cancelText: cancelText ?? 'Cancel',
            onConfirm: onConfirm,
            onCancel: onCancel,
            showCancelButton: showCancelButton ?? false,
          );
          break;
        case ConfirmationDialogType.custom:
          dialog = ConfirmationDialog(
            title: title,
            message: message,
            confirmText: confirmText ?? 'Confirm',
            cancelText: cancelText ?? 'Cancel',
            onConfirm: onConfirm,
            onCancel: onCancel,
            icon: icon ?? Icons.help_outline,
            iconColor: iconColor ?? Colors.blue,
            iconBackgroundColor: iconBackgroundColor ?? const Color(0xFFE3F2FD),
            confirmButtonColor: confirmButtonColor ?? AppColors.primary,
            showCancelButton: showCancelButton ?? true,
          );
          break;
      }
    } else if (title != null && message != null && onConfirm != null) {
      // Fully custom dialog
      dialog = ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText ?? 'Confirm',
        cancelText: cancelText ?? 'Cancel',
        onConfirm: onConfirm,
        onCancel: onCancel,
        icon: icon ?? Icons.help_outline,
        iconColor: iconColor ?? Colors.blue,
        iconBackgroundColor: iconBackgroundColor ?? const Color(0xFFE3F2FD),
        confirmButtonColor: confirmButtonColor ?? AppColors.primary,
        showCancelButton: showCancelButton ?? true,
      );
    } else {
      throw ArgumentError(
        'Either provide type with title, message, and onConfirm, '
        'or provide all custom parameters',
      );
    }

    return showDialog(
      context: context,
      builder: (context) => dialog,
    );
  }
}
