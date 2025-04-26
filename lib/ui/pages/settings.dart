import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/theme_provider.dart';
import '../viewmodels/settings_view_model.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isNotificationsEnabled;
  // Text controllers for adding family members
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  // Gender options for the dropdown
  String? _selectedGender = 'Male'; // Default value for gender

  // Language state
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _isNotificationsEnabled = false; // default until fetched
    _loadNotificationSetting();
    _selectedLanguage =
        Provider.of<SettingsViewModel>(context, listen: false).selectedLanguage;
  }
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

  void _setNotifications(bool value) async {
    final settingsViewModel = Provider.of<SettingsViewModel>(context, listen: false);
    await settingsViewModel.setNotifications(value);
    setState(() {
      _isNotificationsEnabled = value;
    });
  }

  Future<void> _loadNotificationSetting() async {
    final settingsViewModel = Provider.of<SettingsViewModel>(context, listen: false);
    final enabled = await settingsViewModel.getNotifications();

    setState(() {
      _isNotificationsEnabled = enabled;
    });
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

          // Language Row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('settings_language_list'.tr()),
              ),
              DropdownButton<String>(
                value: _selectedLanguage,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLanguage = newValue;
                  });
                  viewModel.setSelectedLanguage(newValue);
                },
                items: viewModel.availableLanguages.map<DropdownMenuItem<String>>((String languageCode) {
                  return DropdownMenuItem<String>(
                    value: languageCode,
                    child: Text(languageCode),
                  );
                }).toList(),
              ),
            ],
          ),

          // Notifications Row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('settings_notifications'.tr()),
              ),
              Switch(
                value: _isNotificationsEnabled,
                onChanged: (bool value) {
                    _setNotifications(value);
                },
              ),
            ],
          ),

          // Dark mode Row
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('settings_dark_mode'.tr()),
              ),
              Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                  viewModel.setDarkModeOn(value);
                },
              ),
            ],
          ),

          // Family Members Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('settings_family_members_title'.tr()),
          ),

          // Input fields for adding family members
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'settings_family_members_name'.tr()),
                ),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'settings_family_members_age'.tr()),
                ),
                // Gender Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('settings_family_members_gender_title'.tr()),
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
                  child: Text('settings_add_family_member'.tr()),
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
