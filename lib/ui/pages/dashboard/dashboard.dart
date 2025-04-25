import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:prepster/ui/viewmodels/dashboard_view_model.dart';
import 'package:provider/provider.dart';

import '../../../model/entities/pantry_item.dart';
import '../../viewmodels/pantry_view_model.dart';
import 'household_list_item.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        Map<String, double> totalAmountPantry = viewModel.calculateTotalPantry();
        List<Map<String, Object>> household = viewModel.getHousehold();

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Dashboard',
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
                      Text(
                        'dashboard_pantry_title'.tr(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${'total_calorie_text'.tr()}${totalAmountPantry["calories"]!.round()} kcal',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${'total_carbs_text'.tr()}${totalAmountPantry["carbs"]!.round()}g carbohydrates',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${'total_protein_text'.tr()}${totalAmountPantry["protein"]!.round()}g protein',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '${'total_fat_text'.tr()}${totalAmountPantry["fat"]!.round()}g fat',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      if (household.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: household.length,
                          itemBuilder: (context, index) {
                            final member = household[index];
                            final name = member['name'] as String? ?? 'Unknown';
                            final age = member['birthYear'] as int?;
                            final sex = member['sex'] as String?;
                            return HouseholdListItem(name: name, age: age, sex: sex);
                          },
                        )
                      else
                        Text('dashboard_no_household'.tr()),
                      const SizedBox(height: 16),
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
