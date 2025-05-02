import 'package:flutter/material.dart';
import 'package:prepster/ui/pages/inventory/new_equipment_item_dialog_popup.dart';
import 'package:prepster/ui/pages/inventory/new_medical_item_dialog_popup.dart';
import 'package:prepster/ui/pages/inventory/tabs/medicine/medical_tab.dart';
import 'package:prepster/ui/pages/inventory/tabs/pantry/pantry_tab.dart';
import 'package:prepster/ui/viewmodels/medical_view_model.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:prepster/model/entities/pantry_item.dart';
import '../../viewmodels/equipment_view_model.dart';
import '../../viewmodels/pantry_view_model.dart';
import 'new_pantry_item_dialog_popup.dart';
import 'tabs/equipment/equipment_tab.dart';

class InventoryPage extends StatefulWidget {
  InventoryPage({super.key});

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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

  void _addMedicalItem(
      String name,
      String amount,
      DateTime? date,
      ) {
    final medicalViewModel = Provider.of<MedicalViewModel>(
      context,
      listen: false,
    );

    medicalViewModel.addItem(
      name: name,
      amount: int.parse(amount),
      expirationDate: date
    );

  }

  void _addEquipmentItem(
      String name,
      String amount,
      DateTime? date,
      ) {
    final equipmentViewModel = Provider.of<EquipmentViewModel>(
      context,
      listen: false,
    );

    equipmentViewModel.addItem(
        name: name,
        amount: int.parse(amount),
        expirationDate: date
    );

  }

  void _displayItemPopup() {
    final currentTab = _tabController.index;

    switch (currentTab) {
      case 0: // Pantry tab
        DateTime? selectedDate;
        showDialog(
          context: context,
          builder: (_) => NewPantryItemDialogPopup(
            selectedDate: selectedDate,
            onSubmit: (name, calories, weight, carbs, protein, fat, date) {
              _addPantryItem(name, calories, weight, carbs, protein, fat, date);
              setState(() {
                selectedDate = date;
              });
            },
          ),
        );
        break;
      case 1: // Medicine tab
        DateTime? selectedDate;
        showDialog(
          context: context,
          builder: (_) => NewMedicalItemDialogPopup(
            selectedDate: selectedDate,
            onSubmit: (name, amount, date) {
              _addMedicalItem(name, amount, date);
              setState(() {
                selectedDate = date;
              });
            },
          ),
        );
        break;
      case 2: // Equipment tab
        DateTime? selectedDate;
        showDialog(
          context: context,
          builder: (_) => NewEquipmentItemDialogPopup(
            selectedDate: selectedDate,
            onSubmit: (name, amount, date) {
              _addEquipmentItem(name, amount, date);
              setState(() {
                selectedDate = date;
              });
            },
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('inventory_page_title'.tr()),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'pantry_tab_name'.tr()),
            Tab(text: 'medicine_tab_name'.tr()),
            Tab(text: 'equipment_tab_name'.tr()),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
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
    );
  }
}
