import '../entities/user.dart';
import '../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<(Failure?, User?)> login(String email, String password);
  Future<(Failure?, User?)> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? countryResidence,
    String? interestCountry,
    required bool terms,
  });
  Future<(Failure?, void)> logout();
  Future<bool> isAuthenticated();
  Future<User?> getCurrentUser();
}
