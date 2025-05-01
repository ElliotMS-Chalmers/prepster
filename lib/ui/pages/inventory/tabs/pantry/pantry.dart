import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:prepster/model/entities/pantry_item.dart';
import 'package:prepster/ui/viewmodels/pantry_view_model.dart';
import 'package:prepster/ui/pages/inventory/tabs/pantry/pantry_list_item.dart';

class PantryTab extends StatefulWidget {
  PantryTab({super.key});

  @override
  _PantryTabState createState() => _PantryTabState();
}

class _PantryTabState extends State<PantryTab> {
  _PantryTabState();

  @override
  Widget build(BuildContext context) {
    return Consumer<PantryViewModel>(
      builder: (context, viewModel, child) {
        List<PantryItem> items = viewModel.getAllItems() as List<PantryItem>;

        return Scaffold(
          body: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: items.length,
            itemBuilder: (context, index) {
              PantryItem item = items[index];
              return PantryListItem(
                item: item,
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