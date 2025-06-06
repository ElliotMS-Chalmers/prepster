import 'package:flutter/material.dart';
import 'package:prepster/model/repositories/inventory_repository.dart';
import 'package:provider/provider.dart';

import 'package:prepster/model/entities/pantry_item.dart';
import 'package:prepster/ui/viewmodels/pantry_view_model.dart';
import 'package:prepster/ui/pages/inventory/tabs/pantry/pantry_list_item.dart';

class PantryTab extends StatelessWidget {
  const PantryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PantryViewModel>(
      builder: (context, viewModel, child) {
        List<PantryItem> items = viewModel.getAllItems();

        return Scaffold(
          body: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: items.length,
            itemBuilder: (context, index) {
              PantryItem item = items[index];
              return PantryListItem(
                item: item,
                id: item.id,
                onEdit: (id, itemType, name, amount, date, calories, weight, categories, excludeFromDateTracker, excludeFromCaloriesTracker) {
                  viewModel.updateItem(
                    id: id,
                    itemType: itemType,
                    name: name,
                    amount: amount,
                    expirationDate: date,
                    calories100g: calories,
                    weightKg: weight,
                    categories: categories,
                    excludeFromDateTracker: excludeFromDateTracker,
                    excludeFromCaloriesTracker: excludeFromCaloriesTracker,
                  );
                },
                //index: index,
                onDelete: (i) => viewModel.deleteItem(i),
              );
            },
          ),
        );
      },
    );
  }
}