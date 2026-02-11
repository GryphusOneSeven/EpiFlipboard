import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _storage = FlutterSecureStorage();
  static const _key = 'jwt';

  static Future<void> saveToken(String token) =>
   _storage.write(key: _key, value: token);

  static Future<String?> getToken() =>
    _storage.read(key: _key);

  static Future<void> clear() =>
    _storage.delete(key: _key);

  static Future<bool> isLoggedIn() async =>
    await getToken() != null;
}