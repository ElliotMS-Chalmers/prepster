import 'package:flutter/material.dart';

import '../../model/repositories/settings_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsRepository _repository;
  List<Map<String, Object>> _items = [];

  SettingsViewModel(this._repository) {
    _loadItems();
  }

  List<Map<String, Object>> getHousehold() => _items;

  Future<void> _loadItems() async {
    _items = await _repository.getHousehold();
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
}

