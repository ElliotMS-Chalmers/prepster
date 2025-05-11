import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
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

  Widget _buildFamilyMemberTile(Map member) {
    final age = DateTime.now().year - (member['birthYear'] as int);
    final gender = 'settings_sex_${member['sex']}'.tr();

    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(member['name']),
      subtitle: Text('$gender, $age'),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => _removeFamilyMember(member['id'].toString()),
      ),
    );
  }

  late bool _isNotificationsEnabled;

  // Text controllers for adding family members
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  // Gender options for the dropdown - changed to use int values (0, 1)
  String _selectedGender = '1'; // Default value for gender (1 = Male)

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
    final settingsViewModel = Provider.of<SettingsViewModel>(
      context,
      listen: false,
    );
    await settingsViewModel.addHouseholdMember(
      name: _nameController.text,
      birthYear:
          DateTime.now().year -
          int.parse(_ageController.text), // assuming age is entered
      sex: _selectedGender,
    );

    _nameController.clear();
    _ageController.clear();

    setState(() {}); // trigger rebuild to show updated list
  }

  // Function to remove a family member
  void _removeFamilyMember(String id) async {
    final settingsViewModel = Provider.of<SettingsViewModel>(
      context,
      listen: false,
    );
    await settingsViewModel.deleteHouseholdMember(id);
    setState(() {}); // refresh UI
  }

  void _setNotifications(bool value) async {
    final settingsViewModel = Provider.of<SettingsViewModel>(
      context,
      listen: false,
    );

    // Call setNotifications and get the result
    final result = await settingsViewModel.setNotifications(value);

    // Only update the UI if permission was granted
    if (result == NotificationPermissionResult.success) {
      setState(() {
        _isNotificationsEnabled = value;
      });
    } else {
      // If permission was denied, revert the switch to its previous state
      setState(() {
        // Keep the previous value, don't change _isNotificationsEnabled
      });

      // Show a message to the user
      if (result == NotificationPermissionResult.permissionDenied) {
        _showPermissionDeniedDialog('permission_denied_message'.tr(), false);
      } else if (result ==
          NotificationPermissionResult.permissionPermanentlyDenied) {
        _showPermissionDeniedDialog(
          'permission_permanently_denied_message'.tr(),
          true,
        );
      }
    }
  }

  // Show a dialog when permission is denied
  void _showPermissionDeniedDialog(String message, bool isPermanentlyDenied) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('permission_required_title'.tr()),
          content: Text(message),
          actions: [
            // Basic OK button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ok_button'.tr()),
            ),
            // If it's permanently denied, offer an option to open settings
            if (isPermanentlyDenied)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  openAppSettings(); // function from permission_handler
                },
                child: Text('open_settings_button'.tr()),
              ),
          ],
        );
      },
    );
  }

  Future<void> _loadNotificationSetting() async {
    final settingsViewModel = Provider.of<SettingsViewModel>(
      context,
      listen: false,
    );
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
      appBar: AppBar(title: Text('bottom_nav_settings'.tr())),
      body: ListView(
        children: [
          // Language Row
          Card(
            color: Theme.of(context).colorScheme.surfaceContainer,
            margin: const EdgeInsets.all(12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  title: Text('settings_language_list'.tr()),
                  trailing: DropdownButton<String>(
                    value: _selectedLanguage,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedLanguage = newValue;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Restart required for changes to take effect')),
                        );
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
                ),
                // Notifications Row
                const Divider(),
                ListTile(
                  title: Text('settings_notifications'.tr()),
                  trailing: Switch(
                    value: _isNotificationsEnabled,
                    onChanged: (bool value) {
                      _setNotifications(value);
                    },
                  ),
                ),
                // Dark Mode Row
                const Divider(),
                ListTile(
                  title: Text('settings_dark_mode'.tr()),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                      viewModel.setDarkModeOn(value);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Display list of family members
          Card(
            color: Theme.of(context).colorScheme.surfaceContainer,
            margin: const EdgeInsets.all(12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'settings_family_members_title'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: household.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final member = household[index];
                      return _buildFamilyMemberTile(member);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Add family members
          Card(
            color: Theme.of(context).colorScheme.surfaceContainer,
            margin: const EdgeInsets.all(12),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'settings_add_family_member'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'settings_family_members_name'.tr(),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'settings_family_members_age'.tr(),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('settings_family_members_gender_title'.tr()),
                  DropdownButton<String>(
                    value: _selectedGender,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue!;
                      });
                    },
                    items: <String>['0', '1'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text('settings_sex_$value'.tr()),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _addFamilyMember,
                      icon: const Icon(Icons.person_add),
                      label: Text('settings_add_family_member'.tr()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
