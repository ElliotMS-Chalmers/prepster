import 'package:flutter/material.dart';
import 'package:prepster/model/repositories/settings_repository.dart';
import 'package:prepster/ui/viewmodels/pantry_view_model.dart';
import 'package:prepster/ui/viewmodels/settings_view_model.dart';
import '../../model/entities/pantry_item.dart';

class DashboardViewModel extends ChangeNotifier {
  final PantryViewModel? _pantryVM;
  final SettingsViewModel? _settingsVM;
  List<PantryItem> _items = [];
  List<Map<String, Object>> _household = [];

  DashboardViewModel(this._pantryVM, this._settingsVM) {
    if (_pantryVM != null && _settingsVM != null) {
      _pantryVM.addListener(_updateDashboardItems);
      _settingsVM.addListener(_updateDashboardItems);
      _updateDashboardItems();
    }
    _loadItems();
    _loadHousehold();
  }

  List<PantryItem> getAllItems() => _items;
  List<Map<String, Object>> getHousehold() => _household;

  Future<void> _loadItems() async {
    _items = await _pantryVM!.getAllItems();
    notifyListeners();
  }

  // This method will be called whenever PantryViewModel calls notifyListeners()
  void _updateDashboardItems() {
    if (_pantryVM != null && _settingsVM != null) {
      // Access the latest data from PantryViewModel
      _loadItems();
      _loadHousehold();
    }
  }

  Future<void> _loadHousehold() async {
    _household = await _settingsVM!.getHousehold();
    notifyListeners();
  }

  double calculateTotalCalories() {
    double total = 0;
    for (var item in _items) {
      if (item.calories100g != null && item.weightKg != null) {
        total += (item.calories100g! * item.weightKg! * 10);
      }
    }

    return total;
  }

  @override
  void dispose() {
    _pantryVM?.removeListener(_updateDashboardItems);
    _settingsVM?.removeListener(_updateDashboardItems);
    super.dispose();
  }
}