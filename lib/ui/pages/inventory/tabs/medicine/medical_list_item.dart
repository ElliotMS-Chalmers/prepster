import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:prepster/model/entities/medical_item.dart';

import '../../../../../model/repositories/inventory_repository.dart';
import '../../../../widgets/list_item.dart';
import '../../new_medical_item_dialog_popup.dart';

class MedicalListItem extends StatelessWidget {
  final MedicalItem item;
  final String id;
  final void Function(String itemId) onDelete;
  final void Function(String itemId, ItemType itemType, String name, int? amount, DateTime? expirationDate, bool? excludeFromDateTracker) onEdit;

  const MedicalListItem({
    super.key,
    required this.item,
    required this.id,
    required this.onDelete,
    required this.onEdit
  });

  void editItem(
      String name,
      String? amount,
      DateTime? date,
      ) async {

    onEdit(id, ItemType.medicalItem, name, int.tryParse(amount ?? ""), date, item.excludeFromDateTracker);
  }

  void displayDialogPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => NewMedicalItemDialogPopup(
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
      title: item.name,
      secondary_text: item.amount.toString(),
      onDelete: onDelete,
      onEdit: () => displayDialogPopup(context),
      details: {
        'Expiration date': item.expirationDate != null ? item.expirationDate!.toString().split(" ")[0] : "None",
      },
    );
  }
}