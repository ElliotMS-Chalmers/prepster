import 'package:flutter/material.dart';
import 'package:prepster/ui/viewmodels/pantry_view_model.dart';
import 'package:prepster/ui/viewmodels/settings_view_model.dart';
import '../../model/entities/pantry_item.dart';
import '../../utils/calorie_calculator.dart';
import '../../utils/logger.dart';

class DashboardViewModel extends ChangeNotifier {
  final PantryViewModel? _pantryVM;
  final SettingsViewModel? _settingsVM;
  List<PantryItem> _items = [];
  List<Map<String, Object>> _household = [];
  LifeQuality _selectedLifeQuality = LifeQuality.medium;
  int _totalHouseholdCalories = 0;
  List<String> excludeFromConsumptionTracker = [];

  DashboardViewModel(this._pantryVM, this._settingsVM) {
    if (_pantryVM != null && _settingsVM != null) {
      _pantryVM.addListener(_updateDashboardItems);
      _settingsVM.addListener(_updateDashboardItems);
      _updateDashboardItems();
      _loadItems();
      _loadHousehold();
      _calculateHouseholdCalories();
    }
  }

  List<PantryItem> getAllItems() => _items;
  List<Map<String, Object>> getHousehold() => _household;
  int get totalHouseholdCalories => _totalHouseholdCalories;

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
      _calculateHouseholdCalories();
      notifyListeners();
    }
  }

  void _loadHousehold() {
    _household = _settingsVM!.getHousehold();
    _calculateHouseholdCalories();
    notifyListeners();
  }

  Future<void> _calculateHouseholdCalories() async {
    _totalHouseholdCalories = await _calculateTotalHouseholdCaloriesInternal();
    notifyListeners();
  }

  Future<int> _calculateTotalHouseholdCaloriesInternal() async {
    int consumption = 0;
    for (var member in _household) {
      if (excludeFromConsumptionTracker.contains(member["id"] as String)) {
        final sex = member['sex'] == 0 ? Gender.female : Gender.male;
        final age = member['birthYear'] as int;
        final calories = CaloriesCalculator().calculateCalories(
          gender: sex,
          age: DateTime.now().year - age,
          lifeQuality: _selectedLifeQuality,
        );
        consumption += await calories;
      }
    }
    return consumption;
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

  LifeQuality get selectedLifeQuality => _selectedLifeQuality;

  void updateLifeQuality(LifeQuality newLifeQuality) {
    _selectedLifeQuality = newLifeQuality;
    _calculateHouseholdCalories();
    logger.i('Life quality set to ${newLifeQuality.name}');
    notifyListeners();
  }

  void changeExcludeConsumption(String id, bool newValue) {
    if (newValue == true) {
      excludeFromConsumptionTracker.add(id);
    }
    else {
      excludeFromConsumptionTracker.remove(id);
    }
    _calculateHouseholdCalories();
  }

  @override
  void dispose() {
    _pantryVM?.removeListener(_updateDashboardItems);
    _settingsVM?.removeListener(_updateDashboardItems);
    super.dispose();
  }
}