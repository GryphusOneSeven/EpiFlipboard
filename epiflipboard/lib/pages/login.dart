import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _loading = false;

  /// Connexion avec email/mot de passe
  Future<void> _loginWithEmail() async {
    setState(() => _loading = true);

    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      setState(() => _loading = false);
      return;
    }

    final success = await _authService.signInWithEmail(email, password);

    if (!mounted) return;

    setState(() => _loading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email ou mot de passe incorrect')),
      );
    }
  }

  /// Connexion Google
  Future<void> _loginWithGoogle() async {
    setState(() => _loading = true);

    final success = await _authService.signInWithGoogle();

    if (!mounted) return;

    setState(() => _loading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connexion Google échouée')),
      );
    }
  }

  /// Aller à la page d'inscription
  void _goToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.red),
              const SizedBox(height: 30),
              const Text(
                'Connexion',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              /// Email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              /// Mot de passe
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              /// Bouton connexion email
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _loginWithEmail,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Se connecter'),
                    ),

              const SizedBox(height: 20),

              /// Bouton inscription
              TextButton(
                onPressed: _goToRegister,
                child: const Text("Pas encore de compte ? S'inscrire"),
              ),

              const SizedBox(height: 20),

              /// Bouton connexion Google
              _loading
                  ? const SizedBox.shrink()
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.login),
                      label: const Text('Se connecter avec Google'),
                      onPressed: _loginWithGoogle,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}