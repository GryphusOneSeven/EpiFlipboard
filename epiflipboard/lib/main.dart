import 'package:epiflipboard/pages/article.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import '/pages/login.dart';
import 'pages/home.dart';
import 'pages/topic.dart';


void main() => runApp(
  DevicePreview(
    builder: (context) => EpiFlipboardApp(), // Wrap your app
  ),
);


class EpiFlipboardApp extends StatelessWidget {
  const EpiFlipboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

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