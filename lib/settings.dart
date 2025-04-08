import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSwitched = true; // Default value for the switch (true or false)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
      ),
      body: Center(
        child: Switch(
          value: _isSwitched,  // Bind the switch to the _isSwitched variable
          onChanged: (bool value) {
            setState(() {
              _isSwitched = value;  // Update the state when the switch is toggled
            });
          },
        ),
      ),
    );
  }
}
