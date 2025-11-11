import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  void _onPressed() {
    Navigator.pushNamed(context, '/article');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _onPressed,
        child: const Text(
          "Go to article page"
        ),
      ),
    );
  }
}