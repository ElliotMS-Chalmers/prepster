import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NewPantryItemDialogPopup extends StatefulWidget {
  final TextEditingController _textController1 = TextEditingController();
  final TextEditingController _textController2 = TextEditingController();
  final TextEditingController _textController3 = TextEditingController();
  final TextEditingController _textController4 = TextEditingController();
  final TextEditingController _textController5 = TextEditingController();
  final TextEditingController _textController6 = TextEditingController();
  final DateTime? selectedDate;
  final void Function(String name, String calories, String weight, String carbs, String protein, String fat, DateTime date) onSubmit;

  NewPantryItemDialogPopup({
    super.key,
    required this.selectedDate,
    required this.onSubmit,
  });

  @override
  State<NewPantryItemDialogPopup> createState() => _NewPantryItemDialogPopupState();
}

class _NewPantryItemDialogPopupState extends State<NewPantryItemDialogPopup> {
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
            controller: widget._textController1,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: widget._textController2,
            decoration: const InputDecoration(labelText: 'Calories per 100g'),
          ),
          TextField(
            controller: widget._textController3,
            decoration: const InputDecoration(labelText: 'Weight in kg'),
          ),
          TextField(
            controller: widget._textController4,
            decoration: const InputDecoration(labelText: 'Carbohydrates per 100g'),
          ),
          TextField(
            controller: widget._textController5,
            decoration: const InputDecoration(labelText: 'Protein per 100g'),
          ),
          TextField(
            controller: widget._textController6,
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
            if (widget._textController1.text.isNotEmpty &&
                widget._textController2.text.isNotEmpty &&
                widget._textController3.text.isNotEmpty &&
                _selectedDate != null) {
              widget.onSubmit(
                widget._textController1.text,
                widget._textController2.text,
                widget._textController3.text,
                widget._textController4.text,
                widget._textController5.text,
                widget._textController6.text,
                _selectedDate!,
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


