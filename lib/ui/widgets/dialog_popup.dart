import 'package:flutter/material.dart';

class NewItemDialogPopup extends StatefulWidget {
  final TextEditingController _textController1 = TextEditingController();
  final TextEditingController _textController2 = TextEditingController();
  final TextEditingController _textController3 = TextEditingController();
  final DateTime? selectedDate;
  final void Function(String name, String calories, String weight, DateTime date) onSubmit;

  NewItemDialogPopup({
    super.key,
    required this.selectedDate,
    required this.onSubmit,
  });

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
      title: const Text('Enter item info'),
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


