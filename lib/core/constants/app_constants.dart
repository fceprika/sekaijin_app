class AppConstants {
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache
  static const Duration cacheValidity = Duration(hours: 1);
  static const Duration imageCacheValidity = Duration(days: 7);

  // Image
  static const int maxImageWidth = 1080;
  static const int maxImageHeight = 1080;
  static const int imageQuality = 85;
  static const int thumbnailSize = 200;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 30;

  // UI
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 8.0;
  static const double cardBorderRadius = 12.0;

  // Animation
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimationDuration = Duration(milliseconds: 150);
}
