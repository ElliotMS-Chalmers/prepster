import 'package:flutter/material.dart';

import 'package:prepster/ui/pages/inventory/tabs/equipment/equipment_list_item.dart';
import 'package:prepster/ui/viewmodels/equipment_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../../model/entities/equipment_item.dart';

class EquipmentTab extends StatelessWidget {
  const EquipmentTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EquipmentViewModel>(
      builder: (context, viewModel, child) {
        List<EquipmentItem> items = viewModel.getAllItems();

        return Scaffold(
          body: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: items.length,
            itemBuilder: (context, index) {
              EquipmentItem item = items[index];
              return EquipmentListItem(
                  item: item,
                  id: item.id,
                  onDelete: (i) => viewModel.deleteItem(i),
                  onEdit: (id, itemType, name, amount, date, excludeFromDateTracker) {
                    viewModel.updateItem(
                        id: id,
                        itemType: itemType,
                        name: name,
                        amount: amount,
                        expirationDate: date,
                        excludeFromDateTracker: excludeFromDateTracker
                    );
                  }
              );
            },
          ),
        );
      },
    );
  }
}