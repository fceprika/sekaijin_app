import '../entities/user.dart';
import '../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<(Failure?, User?)> login(String email, String password);
  Future<(Failure?, void)> logout();
  Future<bool> isAuthenticated();
  Future<User?> getCurrentUser();
}
