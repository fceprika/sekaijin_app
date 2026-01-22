import '../config/app_config.dart';

class ApiEndpoints {
  static String get baseUrl => AppConfig.baseUrl;

  // Auth
  static String get login => '$baseUrl/auth/login';
  static String get register => '$baseUrl/auth/register';
  static String get logout => '$baseUrl/auth/logout';
  static String get refreshToken => '$baseUrl/auth/refresh';

  // User
  static String get userProfile => '$baseUrl/user/profile';
  static String get updateProfile => '$baseUrl/user/profile';

  // Places
  static String get places => '$baseUrl/places';
  static String placeById(String id) => '$baseUrl/places/$id';
  static String placesByCategory(String category) => '$baseUrl/places/category/$category';

  // Search
  static String get search => '$baseUrl/search';

  // Categories
  static String get categories => '$baseUrl/categories';

  // Reviews
  static String get reviews => '$baseUrl/reviews';
  static String reviewsByPlace(String placeId) => '$baseUrl/places/$placeId/reviews';
}
