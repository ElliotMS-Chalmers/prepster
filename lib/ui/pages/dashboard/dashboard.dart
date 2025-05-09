import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:prepster/ui/pages/dashboard/pie_chart.dart';
import 'package:prepster/ui/pages/dashboard/pie_chart_legend.dart';
import 'package:prepster/ui/viewmodels/dashboard_view_model.dart';
import 'package:provider/provider.dart';

import '../../../utils/calorie_calculator.dart';
import 'household_list_item.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewModel>(
      builder: (context, viewModel, child) {
        Map<String, double> totalAmountPantry = viewModel.calculateTotalPantry();
        double totalMacros = totalAmountPantry["carbs"]! + totalAmountPantry["protein"]! + totalAmountPantry["fat"]!;
        List<Map<String, Object>> household = viewModel.getHousehold();
        int totalConsumption = viewModel.totalHouseholdCalories;

        double daysUntilEmpty = 0.0;
        if (totalConsumption > 0 && totalAmountPantry["calories"]! > 0) {
          daysUntilEmpty = totalAmountPantry["calories"]! / totalConsumption;
        }

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
                      SizedBox(
                        height: 300,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            MacronutrientPieChart(
                              carbs: totalAmountPantry["carbs"]!,
                              protein: totalAmountPantry["protein"]!,
                              fat: totalAmountPantry["fat"]!,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 0,
                              children: [
                                Text(
                                  '${totalAmountPantry["calories"]!.round()} kcal',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ]
                        )
                      ),
                      const SizedBox(height: 8),
                      PieChartLegend(
                        items: [
                          LegendItem(color: Colors.cyan, label: 'total_carbs_text'.tr(), value: totalAmountPantry["carbs"]!.round()),
                          LegendItem(color: Colors.redAccent, label: 'total_protein_text'.tr(), value: totalAmountPantry["protein"]!.round()),
                          LegendItem(color: Colors.amber, label: 'total_fat_text'.tr(), value: totalAmountPantry["fat"]!.round()),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ToggleButtons(
                        isSelected: [
                          viewModel.selectedLifeQuality == LifeQuality.low,
                          viewModel.selectedLifeQuality == LifeQuality.medium,
                          viewModel.selectedLifeQuality == LifeQuality.high,
                        ],
                        onPressed: (index) {
                          if (index == 0) {
                            viewModel.updateLifeQuality(LifeQuality.low);
                          } else if (index == 1) {
                            viewModel.updateLifeQuality(LifeQuality.medium);
                          } else if (index == 2) {
                            viewModel.updateLifeQuality(LifeQuality.high);
                          }
                        },
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        constraints: const BoxConstraints(
                          minWidth: 125.0,
                          minHeight: 40.0,
                        ),
                        children: const [
                          Text('Low'),
                          Text('Medium'),
                          Text('High'),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Text(
                        "Estimated time until pantry runs out: ${daysUntilEmpty.round()} days"
                      ),

                      const SizedBox(height: 16),
                      if (household.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: household.length,
                          itemBuilder: (context, index) {
                            final member = household[index];
                            final name = member['name'] as String? ?? 'Unknown';
                            final birthYear = member['birthYear'] as int?;
                            final sex = member['sex'] as String?;

                            // Calculate age from birth year
                            final age = birthYear != null ? DateTime.now().year - birthYear : null;

                            // Pass the formatted sex and age to the list item
                            return HouseholdListItem(
                                memberId: member["id"] as String,
                                name: name,
                                age: age,
                                sex: sex != null ? 'settings_sex_$sex'.tr() : null,
                                onCheckboxChanged: (id, value) => viewModel.changeExcludeConsumption(id, value!),
                            );
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