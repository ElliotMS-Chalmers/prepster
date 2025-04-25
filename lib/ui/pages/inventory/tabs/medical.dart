import 'package:flutter/material.dart';

class MedicalTab extends StatelessWidget {
  const MedicalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('This is the medical tab', style: TextStyle(fontSize: 24))),
    );
  }
}