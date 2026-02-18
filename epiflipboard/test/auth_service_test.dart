import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'package:epiflipboard/services/auth_service.dart';
import 'package:epiflipboard/services/google_sign_in_wrapper.dart';
import 'package:epiflipboard/api/backend_url.dart';

// --- MOCKS ---
class MockGoogleSignIn extends Mock implements IGoogleSignIn {}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}

void main() {
  late AuthService authService;
  late MockGoogleSignIn mockGoogleSignIn;

  setUp(() {
    mockGoogleSignIn = MockGoogleSignIn();
    authService = AuthService(googleSignIn: mockGoogleSignIn);
  });

  group('AuthService.signInWithGoogle', () {
    test('retourne false si l\'utilisateur annule la connexion', () async {
      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
      when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      final result = await authService.signInWithGoogle();
      expect(result, false);
    });

    test('retourne true si connexion réussie', () async {
      final mockAccount = MockGoogleSignInAccount();
      final mockAuth = MockGoogleSignInAuthentication();

      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
      when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => mockAccount);
      when(() => mockAccount.authentication).thenAnswer((_) async => mockAuth);
      when(() => mockAuth.idToken).thenReturn('fake_id_token');

      // Mock du post HTTP
      final fakeResponse = http.Response(jsonEncode({'token': 'jwt_token'}), 200);
      when(() => http.post(
        Uri.parse('$backendBaseUrl/auth/google/mobile'),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => fakeResponse);

      final result = await authService.signInWithGoogle();
      expect(result, true);
    });

    test('retourne false si post HTTP échoue', () async {
      final mockAccount = MockGoogleSignInAccount();
      final mockAuth = MockGoogleSignInAuthentication();

      when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
      when(() => mockGoogleSignIn.signIn()).thenAnswer((_) async => mockAccount);
      when(() => mockAccount.authentication).thenAnswer((_) async => mockAuth);
      when(() => mockAuth.idToken).thenReturn('fake_id_token');

      final fakeResponse = http.Response('Erreur', 500);
      when(() => http.post(
        Uri.parse('$backendBaseUrl/auth/google/mobile'),
        headers: any(named: 'headers'),
        body: any(named: 'body'),
      )).thenAnswer((_) async => fakeResponse);

      final result = await authService.signInWithGoogle();
      expect(result, false);
    });
  });

  group('AuthService.signOut', () {
    test('appelle disconnect', () async {
      when(() => mockGoogleSignIn.disconnect()).thenAnswer((_) async => null);

      await authService.signOut();

      verify(() => mockGoogleSignIn.disconnect()).called(1);
    });
  });
}
