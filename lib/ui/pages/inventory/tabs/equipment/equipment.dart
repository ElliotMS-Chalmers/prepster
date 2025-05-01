import 'package:flutter/material.dart';

import 'package:prepster/ui/pages/inventory/tabs/equipment/equipment_list_item.dart';

class EquipmentTab extends StatelessWidget {
  const EquipmentTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 20,
        itemBuilder: (context, index) {
          return EquipmentListItem(
            index: index,
            onDelete: (i) => null,
          );
        },
      ),
    );
  }
}