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
      _loadItems();
      _loadHousehold();
    }
  }

  List<PantryItem> getAllItems() => _items;
  List<Map<String, Object>> getHousehold() => _household;

  void _loadItems() {
    _items = _pantryVM!.getAllItems() as List<PantryItem>;
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

  void _loadHousehold() {
    _household = _settingsVM!.getHousehold();
    notifyListeners();
  }

  Map<String, double> calculateTotalPantry() {
    double totalcalories = 0;
    double totalCarbs = 0;
    double totalProtein = 0;
    double totalFat = 0;
    for (var item in _items) {
      if (item.weightKg != null) {
        if (item.calories100g != null) {
          totalcalories += (item.calories100g! * item.weightKg! * 10);
        }
        totalCarbs += (item.categories![FoodCategory.carbohydrate]! * item.weightKg! * 10);
        totalProtein += (item.categories![FoodCategory.protein]! * item.weightKg! * 10);
        totalFat += (item.categories![FoodCategory.fat]! * item.weightKg! * 10);
      }

    }

    Map<String, double> total = {"calories": totalcalories, "carbs": totalCarbs, "protein": totalProtein, "fat": totalFat};

    return total;
  }

  @override
  void dispose() {
    _pantryVM?.removeListener(_updateDashboardItems);
    _settingsVM?.removeListener(_updateDashboardItems);
    super.dispose();
  }
}