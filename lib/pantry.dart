import 'package:flutter/material.dart';
import 'package:prepster/model/repositories/pantry_repository.dart';
import 'package:provider/provider.dart';

import 'model/entities/pantry_item.dart';

class PantryPage extends StatefulWidget {
  PantryPage({super.key});

  @override
  _PantryPageState createState() => _PantryPageState();
}

class _PantryPageState extends State<PantryPage> {
  _PantryPageState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<PantryRepository>(
      builder: (context, pantry, child) {
        return FutureBuilder<List<PantryItem>>(
          future: pantry.getAllItems(),
          builder: (context, snapshot) {
            Widget body;

            if (snapshot.connectionState == ConnectionState.waiting) {
              body = Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              body = Center(child: Text('Error: ${snapshot.error}')); // TODO: Handle errors
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                body = Center(child: Text('Pantry is empty'));
            } else {
              List<PantryItem> pantryItems = snapshot.data!;

              body = ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: pantryItems.length,
                itemBuilder: (context, index) {
                  PantryItem item = pantryItems[index];

                  return Dismissible(
                    key: Key(item.name),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Deleted ${item.name} from pantry')));
                      pantry.deleteItem(index);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                item.expirationDate != null ? item.expirationDate.toString().split(" ")[0] : "",
                                style: TextStyle(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                item.weightKg.toString() + " kg",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                (item.calories100g != null && item.weightKg != null
                                    ? ((item.calories100g ?? 0) * (item.weightKg ?? 0) * 10).toString() + " kcal"
                                    : ""),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Pantry',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              body: body
            );
          },
        );
      },
    );
  }
}