import 'package:prepster/model/repositories/inventory_repository.dart';

import '../../model/entities/pantry_item.dart';
import 'inventory_view_model.dart';

class PantryViewModel extends InventoryViewModel<PantryItem> {
  PantryViewModel(InventoryRepository repository) : super(repository);

  Future<void> addItem({
    required String name,
    DateTime? expirationDate,
    double? calories100g,
    Map<FoodCategory, double>? categories,
    bool? excludeFromDateTracker,
    bool? excludeFromCaloriesTracker,
    double? weightKg,
  }) async {
    await repository.addItem(
      itemType: ItemType.pantryItem,
      name: name,
      expirationDate: expirationDate,
      calories100g: calories100g,
      categories: categories,
      excludeFromDateTracker: excludeFromDateTracker,
      excludeFromCaloriesTracker: excludeFromCaloriesTracker,
      weightKg: weightKg,
    );
    await loadItems();
  }
}


