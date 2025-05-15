import 'package:flutter/material.dart';

class HouseholdListItem extends StatefulWidget {
  final String memberId;
  final String name;
  final int? age;
  final String? sex;
  final void Function(String, bool?) onCheckboxChanged;
  final bool initialValue;

  const HouseholdListItem({
    super.key,
    required this.memberId,
    required this.name,
    this.age,
    this.sex,
    required this.onCheckboxChanged,
    this.initialValue = true,
  });

  @override
  _HouseholdListItemState createState() => _HouseholdListItemState();
}

class _HouseholdListItemState extends State<HouseholdListItem> {
  bool isChecked = true;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color getColor(Set<WidgetState> states) {
      const Set<WidgetState> interactiveStates = <WidgetState>{
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.focused,
      };

      if (states.any(interactiveStates.contains)) {
        return colorScheme.primary;
      }

      return colorScheme.primary;
    }

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (widget.sex != null || widget.age != null)
                    Text(
                      '${widget.sex ?? ''}${widget.age != null ? ', ${widget.age}' : ''}',
                      style: const TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
            Checkbox(
              checkColor: Colors.white,
              fillColor: WidgetStateProperty.resolveWith(getColor),
              value: isChecked,
              onChanged: (bool? newValue) {
                setState(() {
                  isChecked = newValue ?? true; // Handle null newValue
                });
                widget.onCheckboxChanged(widget.memberId, newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}
