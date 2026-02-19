import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

import 'google_sign_in_wrapper.dart';
import 'auth_storage.dart';
import '../config/secrets.dart';
import '../api/backend_url.dart';

class AuthService {
  final IGoogleSignIn _googleSignIn;
  final http.Client _client;

  AuthService({
    IGoogleSignIn? googleSignIn,
    http.Client? client,
  })  : _googleSignIn = googleSignIn ??
            GoogleSignInWrapper(
              googleSignIn: GoogleSignIn(
                clientId: googleClientId,
                serverClientId: googleServerClientId,
                scopes: ['email', 'profile'],
              ),
            ),
        _client = client ?? http.Client();

  Future<bool> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false;

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) return false;

      final response = await _client.post(
        Uri.parse('$backendBaseUrl/auth/google/mobile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await AuthStorage.saveToken(data['token']);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
  }
}
