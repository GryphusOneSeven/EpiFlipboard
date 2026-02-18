import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

import 'package:epiflipboard/services/auth_service.dart';
import 'package:epiflipboard/services/google_sign_in_wrapper.dart';
import 'package:epiflipboard/services/auth_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ---------------- MOCKS ----------------
class MockGoogleSignIn extends Mock implements IGoogleSignIn {}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}
class MockHttpClient extends Mock implements http.Client {}
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}
class FakeUri extends Fake implements Uri {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeUri());
    registerFallbackValue(<String, String>{});
  });

  late AuthService authService;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockHttpClient mockClient;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockGoogleSignIn = MockGoogleSignIn();
    mockClient = MockHttpClient();
    mockStorage = MockFlutterSecureStorage();

    // Injection du mock storage
    AuthStorage.testStorage = mockStorage;

    authService = AuthService(
      googleSignIn: mockGoogleSignIn,
      client: mockClient,
    );
  });

  group('AuthService.signInWithGoogle', () {
    test('retourne false si l\'utilisateur annule la connexion', () async {
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async {});
      when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      final result = await authService.signInWithGoogle();

      expect(result, false);
    });

    test('retourne true si connexion réussie', () async {
      final mockAccount = MockGoogleSignInAccount();
      final mockAuth = MockGoogleSignInAuthentication();

      // Mocks Google SignIn
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async {});
      when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => mockAccount);
      when(() => mockAccount.authentication).thenAnswer((_) async => mockAuth);
      when(() => mockAuth.idToken).thenReturn('fake_id_token');

      // Mock storage
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async {});

      // Mock HTTP
      when(() => mockClient.post(
            any<Uri>(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response(jsonEncode({'token': 'jwt_token'}), 200));

      final result = await authService.signInWithGoogle();

      expect(result, true);
      verify(() => mockStorage.write(key: 'jwt', value: 'jwt_token')).called(1);
    });

    test('retourne false si post HTTP échoue', () async {
      final mockAccount = MockGoogleSignInAccount();
      final mockAuth = MockGoogleSignInAuthentication();

      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async {});
      when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => mockAccount);
      when(() => mockAccount.authentication).thenAnswer((_) async => mockAuth);
      when(() => mockAuth.idToken).thenReturn('fake_id_token');

      when(() => mockClient.post(
            any<Uri>(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response('Erreur', 500));

      final result = await authService.signInWithGoogle();

      expect(result, false);
    });
  });

  group('AuthService.signOut', () {
    test('appelle disconnect', () async {
      when(() => mockGoogleSignIn.disconnect()).thenAnswer((_) async {});

      await authService.signOut();

      verify(() => mockGoogleSignIn.disconnect()).called(1);
    });
  });
}
