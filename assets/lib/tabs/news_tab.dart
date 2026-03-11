import 'package:flutter/material.dart';
import 'package:fbla_connect/entities/color_pallete.dart';

class NewsTab extends StatelessWidget {
  const NewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('News'),
        backgroundColor: uniqueTertiaryColor,
      ),
      body: const Center(
        child: Text('News Tab - Coming Soon'),
      ),
    );
  }
}