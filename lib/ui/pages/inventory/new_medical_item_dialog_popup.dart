import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NewMedicalItemDialogPopup extends StatefulWidget {
  final TextEditingController textController1;
  final TextEditingController textController2;
  final DateTime? selectedDate;
  final void Function(String name, String? amount, DateTime? date) onSubmit;

  NewMedicalItemDialogPopup({
    super.key,
    TextEditingController? textController1,
    TextEditingController? textController2,
    required this.selectedDate,
    required this.onSubmit,
  }) :  textController1 = textController1 ?? TextEditingController(),
        textController2 = textController2 ?? TextEditingController();

  @override
  State<NewMedicalItemDialogPopup> createState() => _NewMedicalItemDialogPopupState();
}

class _NewMedicalItemDialogPopupState extends State<NewMedicalItemDialogPopup> {
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('dialog_popup_title'.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widget.textController1,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: widget.textController2,
            decoration: const InputDecoration(labelText: 'Amount'),
          ),
          TextFormField(
            controller: TextEditingController(
              text: _selectedDate == null
                  ? ''
                  : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
            ),
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Expiration Date',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 2),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (widget.textController1.text.isNotEmpty) {
              widget.onSubmit(
                widget.textController1.text,
                widget.textController2.text,
                _selectedDate,
              );
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill out all fields and select a date')),
              );
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}


