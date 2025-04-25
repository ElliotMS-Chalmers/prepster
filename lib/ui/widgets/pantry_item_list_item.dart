import 'package:flutter/material.dart';

import '../../model/entities/pantry_item.dart';

class PantryItemListItem extends StatelessWidget {
  final PantryItem item;
  // final int index; // No longer needed for deleting
  final void Function(String itemId) onDelete;

  const PantryItemListItem({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: Key(item.id), // Use item.id as the key for Dismissible
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted ${item.name} from pantry')),
        );
        onDelete(item.id); // Pass item.id instead of in onDelete
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
                  item.expirationDate != null
                      ? item.expirationDate!.toString().split(" ")[0]
                      : "",
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
                  "${item.weightKg ?? 0} kg",
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  (item.calories100g != null && item.weightKg != null)
                      ? "${(item.calories100g! * item.weightKg! * 10).toStringAsFixed(1)} kcal"
                      : "",
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                    "${(item.categories![FoodCategory.carbohydrate]! * item.weightKg! * 10).toStringAsFixed(1)}g carbs"
                ),
                const SizedBox(width: 12),
                Text(
                    "${(item.categories![FoodCategory.protein]! * item.weightKg! * 10).toStringAsFixed(1)}g protein"
                ),
                const SizedBox(width: 12),
                Text(
                    "${(item.categories![FoodCategory.fat]! * item.weightKg! * 10).toStringAsFixed(1)}g fat"
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}