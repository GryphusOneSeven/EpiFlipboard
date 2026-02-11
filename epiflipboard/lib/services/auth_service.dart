import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'auth_storage.dart';

class AuthService {
  // static const String _backendBaseUrl = "http://127.0.0.1:8000";
  static const String _backendBaseUrl = "http://192.168.1.8:8000";
  // static const String _backendBaseUrl = "https://epiflipboard.onrender.com";

  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: "1011772522292-ilkeppkdepgjkhujvjjfm077fr08m5t5.apps.googleusercontent.com",
    serverClientId: "1011772522292-5jn1vrbh010oihacou850lumgs4g9uoh.apps.googleusercontent.com",
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
          Uri.parse('$_backendBaseUrl/auth/google/mobile'),
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

  // Future<bool> _sendTokenToBackend(String idToken) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$_backendBaseUrl/auth/google/mobile'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode({
  //         'token': idToken,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       print("Succès Backend: ${data['message']}");

  //       await AuthStorage.saveToken(data['token']);

  //     } else {
  //       print("Erreur Backend: ${response.statusCode} - ${response.body}");
  //       throw Exception(response.body);
  //     }
  //   } catch (e) {
  //     print("Erreur de connexion au serveur: $e");
  //   }
  // }
  
  // Déconnexion
  Future<void> signOut() async {
    await _googleSignIn.disconnect();
  }
}