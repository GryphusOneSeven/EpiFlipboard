import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  // Stockage par défaut
  static FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _key = 'jwt';

  // Setter pour tests : permet d'injecter un mock
  static set testStorage(FlutterSecureStorage storage) => _storage = storage;

  static Future<void> saveToken(String token) =>
      _storage.write(key: _key, value: token);

  static Future<String?> getToken() => _storage.read(key: _key);

  static Future<void> clear() => _storage.delete(key: _key);

  static Future<bool> isLoggedIn() async => (await getToken()) != null;
}
