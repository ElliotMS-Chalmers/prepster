import 'package:flutter/material.dart';
import '../model/repositories/settings_repository.dart';

class ThemeProvider with ChangeNotifier {
  final SettingsRepository _settingsRepository;
  bool _isDarkMode = false; // default to light mode

  ThemeProvider(this._settingsRepository);

  bool get isDarkMode => _isDarkMode;

  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> loadTheme() async {
    _isDarkMode = await _settingsRepository.getDarkmodeOn();
    notifyListeners();
  }

  void toggleTheme(bool isOn) async {
    _isDarkMode = isOn;
    await _settingsRepository.setDarkmodeOn(isOn);
    notifyListeners();
  }
}