import 'package:flutter/material.dart';
import 'package:prepster/model/entities/medical_item.dart';
import 'package:prepster/ui/pages/inventory/tabs/medicine/medical_list_item.dart';
import 'package:prepster/ui/viewmodels/medical_view_model.dart';
import 'package:provider/provider.dart';

class MedicalTab extends StatelessWidget {
  const MedicalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicalViewModel>(
      builder: (context, viewModel, child) {
        List<MedicalItem> items = viewModel.getAllItems();

        return Scaffold(
          body: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: items.length,
            itemBuilder: (context, index) {
              MedicalItem item = items[index];
              return MedicalListItem(
                item: item,
                onDelete: (i) => viewModel.deleteItem(i),
              );
            },
          ),
        );
      },
    );
  }
}