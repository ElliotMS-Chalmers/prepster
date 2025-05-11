import 'package:flutter/material.dart';

class PieChartLegend extends StatelessWidget {
  final List<LegendItem> items;

  const PieChartLegend({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: items.map((item) => Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: item.color,
                  ),
                ),
                const SizedBox(width: 6),
                Text(item.label)
              ],
            ),
            if (item.value != null)
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "${item.value}g",
                    textAlign: TextAlign.right,
                  ),
                ],
              )
          ],
        ),).toList(),
      )
    );
  }
}

class LegendItem {
  final Color color;
  final String label;
  final int? value;

  const LegendItem({required this.color, required this.label, this.value});
}
