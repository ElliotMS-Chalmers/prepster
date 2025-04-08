import 'package:flutter/material.dart';

class PantryPage extends StatelessWidget {
  const PantryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pantry Page')),
      body: const Center(child: Text('This is the Pantry Page', style: TextStyle(fontSize: 24))),
    );
  }
}