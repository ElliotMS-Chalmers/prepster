import 'package:flutter/material.dart';

class EquipmentPage extends StatelessWidget {
  const EquipmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Equipment')),
      body: const Center(child: Text('This is the Equipment Page', style: TextStyle(fontSize: 24))),
    );
  }
}