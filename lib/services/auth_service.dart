import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/constants/storage_keys.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage;

  AuthService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
            );

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: StorageKeys.accessToken, value: token);
  }

  Future<String?> getToken() async {
    try {
      return await _secureStorage.read(key: StorageKeys.accessToken);
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: StorageKeys.accessToken);
  }

  Future<bool> isAuthenticated() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: StorageKeys.refreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: StorageKeys.refreshToken);
  }

  Future<void> saveUser(String userJson) async {
    await _secureStorage.write(key: StorageKeys.userId, value: userJson);
  }

  Future<String?> getUser() async {
    return await _secureStorage.read(key: StorageKeys.userId);
  }

  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
