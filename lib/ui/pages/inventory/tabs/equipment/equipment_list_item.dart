import 'package:flutter/material.dart';
import 'package:prepster/model/entities/medical_item.dart';

import '../../../../../model/entities/equipment_item.dart';
import '../../../../widgets/list_item.dart';

class EquipmentListItem extends StatelessWidget {
  final EquipmentItem item;
  final void Function(String itemId) onDelete;

  const EquipmentListItem({
    super.key,
    required this.item,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListItem(
        id: item.id,
        onDismissed: onDelete,
        headerContent:Column(
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
            const SizedBox(width: 8),
            Text(
              "${item.amount}",
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
    );
  }
}