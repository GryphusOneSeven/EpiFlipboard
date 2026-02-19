import 'package:google_sign_in/google_sign_in.dart';

/// Interface pour GoogleSignIn, uniquement les méthodes dont on a besoin
abstract class IGoogleSignIn {
  Future<GoogleSignInAccount?> signIn();
  Future<void> signOut();
  Future<void> disconnect();
}

/// Wrapper concret qui utilise GoogleSignIn
class GoogleSignInWrapper implements IGoogleSignIn {
  final GoogleSignIn _googleSignIn;

  GoogleSignInWrapper({required GoogleSignIn googleSignIn})
      : _googleSignIn = googleSignIn;

  @override
  Future<GoogleSignInAccount?> signIn() => _googleSignIn.signIn();

  @override
  Future<void> signOut() => _googleSignIn.signOut();

  @override
  Future<void> disconnect() => _googleSignIn.disconnect();
}
