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

  static String? pseudo(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le pseudo est requis';
    }
    if (value.length < 3 || value.length > 255) {
      return 'Le pseudo doit contenir entre 3 et 255 caractères';
    }
    // Alphanumeric with . _ - but not at start or end
    final pseudoRegex = RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9]$|^[a-zA-Z0-9]$');
    if (!pseudoRegex.hasMatch(value)) {
      return 'Caractères autorisés: lettres, chiffres, . _ -';
    }
    return null;
  }

  static String? registerPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 12) {
      return 'Le mot de passe doit contenir au moins 12 caractères';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une majuscule';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins une minuscule';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Le mot de passe doit contenir au moins un chiffre';
    }
    return null;
  }

  static String? confirmRegisterPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }
    if (value != password) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  static String? googleMapsUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le lien Google Maps est requis';
    }

    final trimmedValue = value.trim();

    // Check for valid Google Maps URL patterns
    final validPatterns = [
      RegExp(r'^https?://(www\.)?google\.[a-z.]+/maps'),
      RegExp(r'^https?://maps\.google\.[a-z.]+'),
      RegExp(r'^https?://maps\.app\.goo\.gl/'),
      RegExp(r'^https?://goo\.gl/maps/'),
    ];

    final isValid = validPatterns.any((pattern) => pattern.hasMatch(trimmedValue));

    if (!isValid) {
      return 'Veuillez entrer un lien Google Maps valide';
    }

    return null;
  }

  static String? description(String? value, {int minLength = 10}) {
    if (value == null || value.trim().isEmpty) {
      return 'La description est requise';
    }

    if (value.trim().length < minLength) {
      return 'La description doit contenir au moins $minLength caractères';
    }

    return null;
  }

  static String? url(String? value, {String fieldName = 'URL'}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional URL
    }

    final urlRegex = RegExp(
      r'^https?://([\w-]+\.)+[\w-]+(/[\w-./?%&=]*)?$',
      caseSensitive: false,
    );

    if (!urlRegex.hasMatch(value.trim())) {
      return 'Veuillez entrer une $fieldName valide';
    }

    return null;
  }

  static String? positiveNumber(String? value, {String fieldName = 'Ce champ'}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional
    }

    final number = int.tryParse(value.trim());
    if (number == null || number <= 0) {
      return '$fieldName doit être un nombre positif';
    }

    return null;
  }
}
