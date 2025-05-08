import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:prepster/ui/pages/inventory/new_equipment_item_dialog_popup.dart';

import '../../../../../model/entities/equipment_item.dart';
import '../../../../../model/repositories/inventory_repository.dart';
import '../../../../widgets/list_item.dart';

class EquipmentListItem extends StatelessWidget {
  final EquipmentItem item;
  final String id;
  final void Function(String itemId) onDelete;
  final void Function(String itemId, ItemType itemType, String name, int? amount, DateTime? expirationDate, bool? excludeFromDateTracker) onEdit;


  const EquipmentListItem({
    super.key,
    required this.id,
    required this.item,
    required this.onDelete,
    required this.onEdit,
  });

  void editItem(
      String name,
      String? amount,
      DateTime? date,
      ) async {

    onEdit(id, ItemType.equipmentItem, name, int.tryParse(amount ?? ""), date, item.excludeFromDateTracker);
  }

  void displayDialogPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => NewEquipmentItemDialogPopup(
        textController1: TextEditingController(text: item.name),
        textController2: TextEditingController(text: item.amount?.toString() ?? ''),
        selectedDate: item.expirationDate,
        onSubmit: (name, amount, date) {
          editItem(name, amount, date);
          //Navigator.of(context).pop(); // close the dialog
        },
      ),
    );
  }


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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${item.amount}",
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  onPressed: () => displayDialogPopup(context),
                  tooltip: 'edit_button'.tr(),
                  child: const Icon(Icons.edit),
                ),
              ],
            ),
          ],
        ),
    );
  }
}