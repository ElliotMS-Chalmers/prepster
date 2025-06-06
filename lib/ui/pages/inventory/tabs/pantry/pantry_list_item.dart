import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:prepster/ui/pages/inventory/new_pantry_item_dialog_popup.dart';

import '../../../../../model/entities/inventory_item.dart';
import '../../../../../model/entities/pantry_item.dart';
import '../../../../../model/repositories/inventory_repository.dart';
import '../../../../widgets/list_item.dart';

class PantryListItem extends StatelessWidget {
  final PantryItem item;
  final String id;
  final void Function(String itemId) onDelete;
  final void Function(
      String itemId,
      ItemType itemType,
      String name,
      int? amount,
      DateTime? date,
      double? calories,
      double? weight,
      Map<FoodCategory, double>? categories,
      bool? excludeFromDateTracker,
      bool? excludeFromCaloriesTracker) onEdit;

  const PantryListItem({
    super.key,
    required this.item,
    required this.id,
    required this.onDelete,
    required this.onEdit,
  });

  void editItem(
    String name,
    String calories100g,
    String weightKg,
    String? carbs,
    String? protein,
    String? fat,
    DateTime? date,
  ) async {
    final Map<FoodCategory, double> categories = {};

    final parsedCarbs = double.tryParse(carbs ?? '');
    if (parsedCarbs != null) {
      categories[FoodCategory.carbohydrate] = parsedCarbs;
    }

    final parsedProtein = double.tryParse(protein ?? '');
    if (parsedProtein != null) {
      categories[FoodCategory.protein] = parsedProtein;
    }

    final parsedFat = double.tryParse(fat ?? '');
    if (parsedFat != null) {
      categories[FoodCategory.fat] = parsedFat;
    }

    onEdit(id, ItemType.pantryItem, name, item.amount, date, double.parse(calories100g), double.parse(weightKg), categories, item.excludeFromDateTracker, item.excludeFromCaloriesTracker);
  }

  void displayDialogPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => NewPantryItemDialogPopup(
          textController1: TextEditingController(text: item.name),
          textController2: TextEditingController(text: item.calories100g?.toString() ?? ''),
          textController3: TextEditingController(text: item.weightKg?.toString() ?? ''),
          textController4: TextEditingController(
            text: item.categories?[FoodCategory.carbohydrate]?.toString() ?? '',
          ),
          textController5: TextEditingController(
            text: item.categories?[FoodCategory.protein]?.toString() ?? '',
          ),
          textController6: TextEditingController(
            text: item.categories?[FoodCategory.fat]?.toString() ?? '',
          ),
          selectedDate: item.expirationDate,
          onSubmit: (name, calories, weight, carbs, protein, fat, date) {
            editItem(name, calories, weight, carbs, protein, fat, date);
            //Navigator.of(context).pop(); // close the dialog
          },
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListItem(
      id: item.id,
      title: item.name,
      secondary_text: "${item.weightKg} kg",
      onDelete: onDelete,
      onEdit: () => displayDialogPopup(context),
      details: {
        'Expiration date': item.expirationDate != null ? item.expirationDate!.toString().split(" ")[0] : "None",
        'Carbs': "${(item.categories![FoodCategory.carbohydrate]! * item.weightKg! * 10).toStringAsFixed(1)} g",
        'Protein': "${(item.categories![FoodCategory.protein]! * item.weightKg! * 10).toStringAsFixed(1)} g",
        'Fat': "${(item.categories![FoodCategory.fat]! * item.weightKg! * 10).toStringAsFixed(1)} g",
        'Calories': "${(item.calories100g! * item.weightKg! * 10).toStringAsFixed(1)} kcal",
        'Quantity': item.amount.toString()
      },
    );
  }
}
