import 'package:epiflipboard/models/article.dart';
import 'package:epiflipboard/pages/article.dart';
import 'package:epiflipboard/pages/createMagazine.dart';
import 'package:epiflipboard/pages/selectMagazine.dart';
import 'package:epiflipboard/pages/sourceArticles.dart';
// import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'pages/register.dart';
import 'pages/login.dart';
import 'pages/home.dart';
import 'pages/topic.dart';
import 'services/auth_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final loggedIn = await AuthStorage.isLoggedIn();

  // runApp(
  //   DevicePreview(
  //     builder: (context) => EpiFlipboardApp(),
  //   ),
  // );
  runApp(
    const EpiFlipboardApp(),
  );
}

ThemeData _buildDarkTheme() {
  const red = Color(0xFFE50914);

  return ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: Color.fromARGB(255, 37, 37, 37),

    colorScheme: const ColorScheme.dark(
      primary: red,
      secondary: red,
      surface: Color.fromARGB(255, 37, 37, 37),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 37, 37, 37),
      elevation: 0,
      centerTitle: false,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    focusColor: red,
    highlightColor: red.withAlpha(1),
    splashColor: red.withAlpha(12),
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
          theme: _buildDarkTheme(),
          home: loggedIn ? const HomePage() : const LoginPage(),
          routes: {
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/home': (context) => const HomePage(),
            '/topic': (context) => const TopicPage(),
            '/article': (context) => const ArticlePage(),
            '/createMagazine': (context) => const CreateMagazinePage(),
            '/selectMagazine': (context) => SelectMagazinePage(article: Article.empty()),
            '/sourceArticles': (context) => SourceArticlesPage(),
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
