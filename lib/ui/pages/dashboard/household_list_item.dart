import 'package:flutter/material.dart';

class HouseholdListItem extends StatelessWidget {
  final String name;
  final int? age;
  final String? sex;

  const HouseholdListItem({
    super.key,
    required this.name,
    this.age,
    this.sex,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (sex != null || age != null)
              Text(
                '${sex ?? ''}${age != null ? ', $age' : ''}',
                style: const TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}