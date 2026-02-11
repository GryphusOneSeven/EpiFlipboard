import 'package:epiflipboard/pages/article.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/home.dart';
import 'pages/topic.dart';
import 'services/auth_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final loggedIn = await AuthStorage.isLoggedIn();

  runApp(
    DevicePreview(
      builder: (context) => EpiFlipboardApp(),
    ),
  );
}

class EpiFlipboardApp extends StatelessWidget {
  const EpiFlipboardApp({super.key});

  Future<bool> _isLoggedIn() async {
    return AuthStorage.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final loggedIn = snapshot.data!;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: loggedIn ? const HomePage() : const LoginPage(),
          routes: {
            '/login': (context) => const LoginPage(),
            '/home': (context) => const HomePage(),
            '/topic': (context) => const TopicPage(),
            '/article': (context) => const ArticlePage(),
          },
        );
      },
    );
  }
}

// Future<void> logout(BuildContext context) async {
//   await AuthStorage.clear();
//   await googleSignIn.disconnect();

//   Navigator.of(context)
//     .pushReplacementNamed('/login');

// }
