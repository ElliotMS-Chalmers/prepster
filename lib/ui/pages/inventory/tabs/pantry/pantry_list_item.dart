import 'package:flutter/material.dart';

import '../../../../../model/entities/pantry_item.dart';
import '../../../../widgets/dismissible_list_item.dart';

class PantryListItem extends StatelessWidget {
  final PantryItem item;
  final void Function(String itemId) onDelete;

  const PantryListItem({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DismissibleListItem(
        id: item.id,
        onDismissed: onDelete,
        child:Column(
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
                const SizedBox(width: 8),
                Text(
                  (item.calories100g != null && item.weightKg != null)
                      ? "${(item.calories100g! * item.weightKg! * 10).toStringAsFixed(1)} kcal"
                      : "",
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                    "${(item.categories![FoodCategory.carbohydrate]! * item.weightKg! * 10).toStringAsFixed(1)}g carbs"
                ),
                const SizedBox(width: 8),
                Text(
                    "${(item.categories![FoodCategory.protein]! * item.weightKg! * 10).toStringAsFixed(1)}g protein"
                ),
                const SizedBox(width: 8),
                Text(
                    "${(item.categories![FoodCategory.fat]! * item.weightKg! * 10).toStringAsFixed(1)}g fat"
                ),
              ],
            ),
          ],
        ),
    );
  }
}