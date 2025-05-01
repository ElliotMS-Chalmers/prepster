import 'package:flutter/material.dart';
import 'package:prepster/ui/pages/inventory/tabs/medicine/medical_list_item.dart';

class MedicalTab extends StatelessWidget {
  const MedicalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 3,
        itemBuilder: (context, index) {
          return MedicalListItem(
            index: index,
            onDelete: (i) => null,
          );
        },
      ),
    );
  }
}