import 'package:flutter/material.dart';

import '../config/theme.dart';

class SnackbarHelper {
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.secondary,
      icon: Icons.check_circle,
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error,
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }

  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.primary,
      icon: Icons.info,
    );
  }

  static void showWarning(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.rating,
      icon: Icons.warning,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        duration: duration,
        action: action,
      ),
    );
  }

  // Predefined success messages
  static const String loginSuccess = 'Connexion réussie';
  static const String registerSuccess = 'Bienvenue sur Sekaijin !';
  static const String createPlaceSuccess = 'Lieu créé avec succès';
  static const String createReviewSuccess = 'Avis ajouté avec succès';
  static const String updateReviewSuccess = 'Avis mis à jour';
  static const String deleteReviewSuccess = 'Avis supprimé';

  // Predefined error messages
  static const String networkError = 'Vérifiez votre connexion internet';
  static const String serverError = 'Une erreur est survenue, réessayez plus tard';
  static const String authError = 'Session expirée, veuillez vous reconnecter';
}
