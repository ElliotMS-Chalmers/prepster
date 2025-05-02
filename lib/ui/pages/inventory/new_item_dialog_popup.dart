import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NewItemDialogPopup extends StatefulWidget {
  final TextEditingController textController1;
  final TextEditingController textController2;
  final TextEditingController textController3;
  final TextEditingController textController4;
  final TextEditingController textController5;
  final TextEditingController textController6;
  final DateTime? selectedDate;
  final void Function(String name, String calories, String weight, String? carbs, String? protein, String? fat, DateTime? date) onSubmit;

  NewItemDialogPopup({
    super.key,
    TextEditingController? textController1,
    TextEditingController? textController2,
    TextEditingController? textController3,
    TextEditingController? textController4,
    TextEditingController? textController5,
    TextEditingController? textController6,
    required this.selectedDate,
    required this.onSubmit,
  }) :  textController1 = textController1 ?? TextEditingController(),
        textController2 = textController2 ?? TextEditingController(),
        textController3 = textController3 ?? TextEditingController(),
        textController4 = textController4 ?? TextEditingController(),
        textController5 = textController5 ?? TextEditingController(),
        textController6 = textController6 ?? TextEditingController();

  @override
  State<NewItemDialogPopup> createState() => _NewItemDialogPopupState();
}

class _NewItemDialogPopupState extends State<NewItemDialogPopup> {
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
            decoration: const InputDecoration(labelText: 'Calories per 100g'),
          ),
          TextField(
            controller: widget.textController3,
            decoration: const InputDecoration(labelText: 'Weight in kg'),
          ),
          TextField(
            controller: widget.textController4,
            decoration: const InputDecoration(labelText: 'Carbohydrates per 100g'),
          ),
          TextField(
            controller: widget.textController5,
            decoration: const InputDecoration(labelText: 'Protein per 100g'),
          ),
          TextField(
            controller: widget.textController6,
            decoration: const InputDecoration(labelText: 'Fat per 100g'),
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
            if (widget.textController1.text.isNotEmpty &&
                widget.textController2.text.isNotEmpty &&
                widget.textController3.text.isNotEmpty) {
              widget.onSubmit(
                widget.textController1.text,
                widget.textController2.text,
                widget.textController3.text,
                widget.textController4.text,
                widget.textController5.text,
                widget.textController6.text,
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


