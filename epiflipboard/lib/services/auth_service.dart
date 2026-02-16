import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
import 'auth_storage.dart';
import '../config/secrets.dart';
import '../api/backend_url.dart';

class AuthService {

  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: googleClientId,
    serverClientId: googleServerClientId,
    scopes: [
      'email',
      'profile',
    ],
  );

  Future<bool> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      // 1. Déclencher le flux de connexion natif
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // L'utilisateur a annulé la connexion
        return false;
      }

      // 2. Récupérer les détails de l'authentification (tokens)
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // L'idToken est la preuve d'identité signée par Google
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken == null) return false;

      if (idToken != null) {
        print("Google ID Token récupéré: ${idToken.substring(0, 10)}...");
        print("idToken = $idToken");

        final response = await http.post(
          Uri.parse('$backendBaseUrl/auth/google/mobile'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'token': idToken,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          await AuthStorage.saveToken(data['token']);
          return true;
        }
        
        return false;
      }

    } catch (error) {
      print("Erreur lors de la connexion Google: $error");
      return false;
    }
  }
  
  // Déconnexion
  Future<void> signOut() async {
    await _googleSignIn.disconnect();
  }
}