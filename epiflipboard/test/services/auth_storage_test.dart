import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:epiflipboard/services/auth_storage.dart';

// --- Mock du FlutterSecureStorage ---
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    // Injection du mock dans AuthStorage
    AuthStorage.testStorage = mockStorage;
  });

  group('AuthStorage', () {
    test('saveToken appelle write avec la bonne clé et valeur', () async {
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) => Future.value());

      await AuthStorage.saveToken('my_jwt_token');

      verify(() => mockStorage.write(key: 'jwt', value: 'my_jwt_token')).called(1);
    });

    test('getToken retourne la valeur du stockage', () async {
      when(() => mockStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => 'my_jwt_token');

      final token = await AuthStorage.getToken();

      expect(token, 'my_jwt_token');
      verify(() => mockStorage.read(key: 'jwt')).called(1);
    });

    test('clear appelle delete avec la bonne clé', () async {
      when(() => mockStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) => Future.value());

      await AuthStorage.clear();

      verify(() => mockStorage.delete(key: 'jwt')).called(1);
    });

    test('isLoggedIn retourne true si getToken != null', () async {
      when(() => mockStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => 'jwt_token');

      final loggedIn = await AuthStorage.isLoggedIn();

      expect(loggedIn, true);
      verify(() => mockStorage.read(key: 'jwt')).called(1);
    });

    test('isLoggedIn retourne false si getToken == null', () async {
      when(() => mockStorage.read(key: any(named: 'key')))
          .thenAnswer((_) async => null);

      final loggedIn = await AuthStorage.isLoggedIn();

      expect(loggedIn, false);
      verify(() => mockStorage.read(key: 'jwt')).called(1);
    });
  });
}
