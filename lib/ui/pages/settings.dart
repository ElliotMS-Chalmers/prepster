import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/theme_provider.dart';
import '../viewmodels/settings_view_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isNotificationsEnabled = true;

  // Text controllers for adding family members
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  // Gender options for the dropdown
  String? _selectedGender = 'Male'; // Default value for gender

  // Function to add a family member
  void _addFamilyMember() async {
    final settingsViewModel = Provider.of<SettingsViewModel>(context, listen: false);
    await settingsViewModel.addHouseholdMember(
      name: _nameController.text,
      birthYear: DateTime.now().year - int.parse(_ageController.text), // assuming age is entered
      sex: _selectedGender!,
    );

    _nameController.clear();
    _ageController.clear();

    setState(() {}); // trigger rebuild to show updated list
  }

  // Function to remove a family member
  void _removeFamilyMember(String id) async {
    final settingsViewModel = Provider.of<SettingsViewModel>(context, listen: false);
    await settingsViewModel.deleteHouseholdMember(id);
    setState(() {}); // refresh UI
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SettingsViewModel>(context);
    final household = viewModel.getHousehold();
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
                  items: <String>['Male', 'Female']
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
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: household.length,
            itemBuilder: (context, index) {
              final member = household[index];
              return ListTile(
                title: Text('${member['name']}'),
                subtitle: Text('Born: ${member['birthYear']} - ${member['sex']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeFamilyMember(member['id'].toString()),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
