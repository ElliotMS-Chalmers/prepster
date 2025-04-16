import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/entities/pantry_item.dart';
import '../viewmodels/pantry_view_model.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});


  double _calculateTotalCalories(List<PantryItem> items) {
    double total = 0;
    for (var item in items) {
        if (item.calories100g != null && item.weightKg != null) {
            total += (item.calories100g! * item.weightKg! * 10);
        }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PantryViewModel>(
      builder: (context, viewModel, child) {
        List<PantryItem> items = viewModel.getAllItems();
        double totalCalories = _calculateTotalCalories(items);

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Dashboard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      // Placeholder pie chart image
                      Image.asset(
                        'lib/ui/pages/assets/piechart-placeholder.png',
                        height: 200,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Pantry Overview',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Total Calories in pantry: ${totalCalories.round()}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
