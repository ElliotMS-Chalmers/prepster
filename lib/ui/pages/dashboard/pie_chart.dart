import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MacronutrientPieChart extends StatelessWidget {
  final double carbs;
  final double protein;
  final double fat;

  const MacronutrientPieChart({
    super.key,
    required this.carbs,
    required this.protein,
    required this.fat,
  });

  @override
  Widget build(BuildContext context) {
    final total = carbs + protein + fat;

    return PieChart(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      PieChartData(
        centerSpaceRadius: double.infinity,
        sectionsSpace: 0,
        sections: [
          PieChartSectionData(
            value: carbs,
            color: Colors.cyan,
            radius: 75,
            title: "${((carbs / total) * 100).toStringAsFixed(1)}%",
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: protein,
            color: Colors.redAccent,
            radius: 75,
            title: "${((protein / total) * 100).toStringAsFixed(1)}%",
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          PieChartSectionData(
            value: fat,
            color: Colors.amber,
            radius: 75,
            title: "${((fat / total) * 100).toStringAsFixed(1)}%",
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
