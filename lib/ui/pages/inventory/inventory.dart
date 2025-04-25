import 'package:flutter/material.dart';
import 'package:prepster/ui/pages/inventory/tabs/medical.dart';
import 'package:prepster/ui/pages/inventory/tabs/pantry/pantry.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:prepster/model/entities/pantry_item.dart';
import '../../viewmodels/pantry_view_model.dart';
import 'new_item_dialog_popup.dart';
import 'tabs/equipment.dart';

class InventoryPage extends StatefulWidget {
  InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  _InventoryPageState();

  void _addPantryItem(
      String name,
      String calories100g,
      String weightKg,
      String? carbs,
      String? protein,
      String? fat,
      DateTime? date,
      ) {
    final pantryViewModel = Provider.of<PantryViewModel>(
      context,
      listen: false,
    );

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

    pantryViewModel.addItem(
      name: name,
      calories100g: double.parse(calories100g),
      weightKg: double.parse(weightKg),
      categories: categories,
      expirationDate: date,
    );
  }

  void _displayItemPopup() {
    DateTime? selectedDate;
    showDialog(
      context: context,
      builder:
          (_) => NewItemDialogPopup(
        selectedDate: selectedDate,
        onSubmit: (name, calories, weight, carbs, protein, fat, date) {
          _addPantryItem(name, calories, weight, carbs, protein, fat, date);
          setState(() {
            selectedDate = date;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('inventory_page_title'.tr()),
          bottom: TabBar(
            tabs: [
              Tab(text: 'pantry_tab_name'.tr()),
              Tab(text: 'medicine_tab_name'.tr()),
              Tab(text: 'equipment_tab_name'.tr()),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PantryTab(),
            MedicalTab(),
            EquipmentTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _displayItemPopup,
          tooltip: 'tooltip_add_pantry_item'.tr(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
