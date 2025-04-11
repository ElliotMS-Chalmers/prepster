import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/entities/pantry_item.dart';
import '../viewmodels/pantry_view_model.dart';
import '../widgets/pantry_item_list_item.dart';

class PantryPage extends StatefulWidget {
  PantryPage({super.key});

  @override
  _PantryPageState createState() => _PantryPageState();
}

class _PantryPageState extends State<PantryPage> {
  _PantryPageState();

  @override
  Widget build(BuildContext context) {
    return Consumer<PantryViewModel>(
      builder: (context, viewModel, child) {
        List<PantryItem> items = viewModel.getAllItems();

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Pantry',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: items.length,
            itemBuilder: (context, index) {
              PantryItem item = items[index];
              return PantryItemListItem(
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
