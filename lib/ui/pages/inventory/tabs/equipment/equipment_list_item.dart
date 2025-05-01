import 'package:flutter/material.dart';

import '../../../../widgets/list_item.dart';

class EquipmentListItem extends StatelessWidget {
  final int index;
  final void Function(String itemId) onDelete;

  const EquipmentListItem({
    super.key,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListItem(
      id: index.toString(),
      onDismissed: onDelete,
      expandedContent: Text("expanded test"),
      headerContent:Text("test item")
    );
  }
}