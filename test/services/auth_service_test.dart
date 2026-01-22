import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sekaijin_app/services/auth_service.dart';

class FakeFlutterSecureStorage implements FlutterSecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value != null) {
      _storage[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _storage[key];
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _storage.remove(key);
  }

  @override
  Future<void> deleteAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _storage.clear();
  }

  @override
  Future<bool> containsKey({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _storage.containsKey(key);
  }

  @override
  Future<Map<String, String>> readAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return Map.from(_storage);
  }

  @override
  IOSOptions get iOptions => IOSOptions.defaultOptions;

  @override
  AndroidOptions get aOptions => AndroidOptions.defaultOptions;

  @override
  LinuxOptions get lOptions => LinuxOptions.defaultOptions;

  @override
  WebOptions get webOptions => WebOptions.defaultOptions;

  @override
  MacOsOptions get mOptions => MacOsOptions.defaultOptions;

  @override
  WindowsOptions get wOptions => WindowsOptions.defaultOptions;

  @override
  Future<bool> isCupertinoProtectedDataAvailable() async => true;

  @override
  Stream<bool> get onCupertinoProtectedDataAvailabilityChanged =>
      Stream.value(true);

  @override
  void registerListener({
    required String key,
    required ValueChanged<String?> listener,
  }) {}

  @override
  void unregisterListener({
    required String key,
    required ValueChanged<String?> listener,
  }) {}

  @override
  void unregisterAllListenersForKey({required String key}) {}

  @override
  void unregisterAllListeners() {}
}

void main() {
  late AuthService authService;
  late FakeFlutterSecureStorage fakeStorage;

  setUp(() {
    fakeStorage = FakeFlutterSecureStorage();
    authService = AuthService(secureStorage: fakeStorage);
  });

  group('AuthService', () {
    test('saveToken and getToken work correctly', () async {
      const token = 'test_token_123';

      await authService.saveToken(token);
      final retrievedToken = await authService.getToken();

      expect(retrievedToken, equals(token));
    });

    test('deleteToken removes the token', () async {
      const token = 'test_token_123';

      await authService.saveToken(token);
      await authService.deleteToken();
      final retrievedToken = await authService.getToken();

      expect(retrievedToken, isNull);
    });

    test('isAuthenticated returns true when token exists', () async {
      const token = 'test_token_123';

      await authService.saveToken(token);
      final isAuth = await authService.isAuthenticated();

      expect(isAuth, isTrue);
    });

    test('isAuthenticated returns false when no token', () async {
      final isAuth = await authService.isAuthenticated();

      expect(isAuth, isFalse);
    });

    test('clearAll removes all data', () async {
      await authService.saveToken('token');
      await authService.saveRefreshToken('refresh');
      await authService.saveUser('{"id": 1}');

      await authService.clearAll();

      expect(await authService.getToken(), isNull);
      expect(await authService.getRefreshToken(), isNull);
      expect(await authService.getUser(), isNull);
    });

    test('saveUser and getUser work correctly', () async {
      const userJson = '{"id": 1, "name": "Test User"}';

      await authService.saveUser(userJson);
      final retrievedUser = await authService.getUser();

      expect(retrievedUser, equals(userJson));
    });

    test('saveRefreshToken and getRefreshToken work correctly', () async {
      const refreshToken = 'refresh_token_123';

      await authService.saveRefreshToken(refreshToken);
      final retrievedToken = await authService.getRefreshToken();

      expect(retrievedToken, equals(refreshToken));
    });
  });
}
