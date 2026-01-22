import 'user_model.dart';

class AuthResponse {
  final bool success;
  final String message;
  final UserModel? user;
  final String? token;

  const AuthResponse({
    required this.success,
    required this.message,
    this.user,
    this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] == true,
      message: json['message'] as String? ?? '',
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      token: json['token'] as String?,
    );
  }

  bool get isSuccess => success && token != null;
}
