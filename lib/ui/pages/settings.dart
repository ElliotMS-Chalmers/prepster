import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isNotificationsEnabled = true;

  // List to store family members
  List<Map<String, String>> _familyMembers = [];

  // Text controllers for adding family members
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  // Gender options for the dropdown
  String? _selectedGender = 'Male'; // Default value for gender

  // Function to add a family member
  void _addFamilyMember() {
    setState(() {
      _familyMembers.add({
        'name': _nameController.text,
        'age': _ageController.text,
        'gender': _selectedGender!,
      });
    });

    // Clear the text fields after adding
    _nameController.clear();
    _ageController.clear();
  }

  // Function to remove a family member
  void _removeFamilyMember(int index) {
    setState(() {
      _familyMembers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
      ),
      body: ListView(
        children: [
          // Notifications Row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Notifications'),
              ),
              Switch(
                value: _isNotificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _isNotificationsEnabled = value;
                  });
                },
              ),
            ],
          ),

          // Notifications Row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Dark Mode'),
              ),
              Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            ],
          ),

          // Family Members Section
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Family Members'),
          ),

          // Input fields for adding family members
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age'),
                ),
                // Gender Dropdown
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Gender'),
                ),
                DropdownButton<String>(
                  value: _selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  items: <String>['Male', 'Female', 'Anka']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addFamilyMember,
                  child: const Text('Add Family Member'),
                ),
              ],
            ),
          ),

          // Display list of family members
          ListView.builder(
            shrinkWrap: true,  // To prevent scrolling issues inside ListView
            physics: NeverScrollableScrollPhysics(), // Disable scrolling here
            itemCount: _familyMembers.length,
            itemBuilder: (context, index) {
              final familyMember = _familyMembers[index];
              return ListTile(
                title: Text('${familyMember['name']} (${familyMember['age']}, ${familyMember['gender']})'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeFamilyMember(index),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
