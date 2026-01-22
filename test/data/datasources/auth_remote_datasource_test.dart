import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/data/models/auth_response.dart';

void main() {
  group('AuthResponse', () {
    test('fromJson parses successful login response', () {
      final json = {
        'success': true,
        'message': 'Connexion réussie',
        'user': {
          'id': 1,
          'name': 'testuser',
          'name_slug': 'testuser',
          'email': 'test@example.com',
          'created_at': '2024-01-01T00:00:00.000Z',
        },
        'token': 'test_token_123',
      };

      final response = AuthResponse.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, 'Connexion réussie');
      expect(response.token, 'test_token_123');
      expect(response.user, isNotNull);
      expect(response.user!.email, 'test@example.com');
      expect(response.isSuccess, isTrue);
    });

    test('fromJson parses failed login response', () {
      final json = {
        'success': false,
        'message': 'Identifiants incorrects',
      };

      final response = AuthResponse.fromJson(json);

      expect(response.success, isFalse);
      expect(response.message, 'Identifiants incorrects');
      expect(response.token, isNull);
      expect(response.user, isNull);
      expect(response.isSuccess, isFalse);
    });

    test('fromJson handles missing message', () {
      final json = {
        'success': true,
        'token': 'test_token',
      };

      final response = AuthResponse.fromJson(json);

      expect(response.success, isTrue);
      expect(response.message, '');
    });

    test('isSuccess returns false when token is null', () {
      final json = {
        'success': true,
        'message': 'OK',
        'user': {
          'id': 1,
          'name': 'testuser',
          'name_slug': 'testuser',
          'email': 'test@example.com',
          'created_at': '2024-01-01T00:00:00.000Z',
        },
      };

      final response = AuthResponse.fromJson(json);

      expect(response.success, isTrue);
      expect(response.isSuccess, isFalse);
    });
  });
}
