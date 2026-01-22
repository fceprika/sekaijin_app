import '../constants/app_constants.dart';

class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'Le mot de passe doit contenir au moins ${AppConstants.minPasswordLength} caractères';
    }
    if (value.length > AppConstants.maxPasswordLength) {
      return 'Le mot de passe ne peut pas dépasser ${AppConstants.maxPasswordLength} caractères';
    }
    return null;
  }

  static String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le nom d\'utilisateur est requis';
    }
    if (value.length < AppConstants.minUsernameLength) {
      return 'Le nom d\'utilisateur doit contenir au moins ${AppConstants.minUsernameLength} caractères';
    }
    if (value.length > AppConstants.maxUsernameLength) {
      return 'Le nom d\'utilisateur ne peut pas dépasser ${AppConstants.maxUsernameLength} caractères';
    }
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Le nom d\'utilisateur ne peut contenir que des lettres, chiffres et underscores';
    }
    return null;
  }

  static String? required(String? value, {String fieldName = 'Ce champ'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }
    if (value != password) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(' ', ''))) {
      return 'Veuillez entrer un numéro de téléphone valide';
    }
    return null;
  }
}
