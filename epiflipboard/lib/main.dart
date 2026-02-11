import 'package:epiflipboard/pages/article.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import '/pages/login.dart';
import 'pages/home.dart';
import 'pages/topic.dart';


void main() => runApp(
  DevicePreview(
    builder: (context) => EpiFlipboardApp(),
  ),
);

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildDarkTheme(),

      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/topic': (context) => const TopicPage(),
        '/article': (context) => const ArticlePage(),
      },
      initialRoute: '/login',
    );
  }
}