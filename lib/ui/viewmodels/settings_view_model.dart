import 'package:flutter/material.dart';

import '../../model/repositories/settings_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsRepository _repository;
  List<Map<String, Object>> _items = [];
  String? _selectedLanguage;
  List<String> _availableLanguages = [];

  SettingsViewModel(this._repository) {
    _initialize();
  }

  List<Map<String, Object>> getHousehold() => _items;
  String? get selectedLanguage => _selectedLanguage;
  List<String> get availableLanguages => _availableLanguages;


  Future<void> _initialize() async {
    // IMPORTANT need to initialize cache before using the repository!
    await _repository.initializeCache();
    await _loadItems();
    await _loadAvailableLanguages();
    await _loadSelectedLanguage();
  }

  Future<void> _loadItems() async {
    _items = await _repository.getHousehold();
    notifyListeners();
  }

  Future<void> _loadAvailableLanguages() async {
    _availableLanguages = _repository.getAvailableLanguages();
    notifyListeners();
  }

  Future<void> _loadSelectedLanguage() async {
    _selectedLanguage = await _repository.getSelectedLanguage();
    notifyListeners();
  }

  Future<void> addHouseholdMember({
    required String name,
    required int birthYear,
    required String sex,
  }) async {
    await _repository.addHouseholdMember(
      name: name,
      birthYear: birthYear,
      sex: sex,
    );
    await _loadItems();
  }

  Future<void> deleteHouseholdMember(String itemId) async {
    await _repository.deleteHouseholdMember(itemId);
    //_items.removeAt(itemId);
    //notifyListeners();
    await _loadItems();
  }

  Future<bool> getNotifications() async {
    return await _repository.getNotificationsEnabled();
  }

  Future<void> setNotifications(bool value) async {
    await _repository.setNotifications(value);
  }

  Future<void> setDarkModeOn(bool value) async {
    await _repository.setDarkmodeOn(value);
  }

  Future<void> setSelectedLanguage(String? languageCode) async {
    if (languageCode != null && _selectedLanguage != languageCode) {
      final success = await _repository.setLanguage(languageCode);
      if (success) {
        _selectedLanguage = languageCode;
        notifyListeners();
        //TODO: Add a UI refresh here
      } else {
        print('Failed to set language to $languageCode');
      }
    }
  }
}

