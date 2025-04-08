import 'package:flutter/material.dart';

class MedicalPage extends StatelessWidget {
  const MedicalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medical Page')),
      body: const Center(child: Text('This is the Medical Page', style: TextStyle(fontSize: 24))),
    );
  }
}