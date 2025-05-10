import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:prepster/utils/api_getter.dart';

class SearchPage extends StatefulWidget {
  final String initialQuery;

  const SearchPage({super.key, required this.initialQuery});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class SelectedFood {
  final String name;
  final Map<String, double?> nutrients;

  SelectedFood({required this.name, required this.nutrients});
}

class _SearchPageState extends State<SearchPage> {
  final ApiGetter apiGetter = ApiGetter();
  late Future<List<_FoodItem>> _foodItemsFuture;

  @override
  void initState() {
    super.initState();
    _foodItemsFuture = _fetchFoodItems(widget.initialQuery);
  }

  Future<List<_FoodItem>> _fetchFoodItems(String query) async {
    final ids = await apiGetter.fetchFoodIdsByName(query);
    final List<_FoodItem> results = [];

    for (final id in ids) {
      final name = await apiGetter.fetchFoodById(id);
      results.add(_FoodItem(id: id, name: name));
    }

    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('API_Search_Results_for'.tr() + widget.initialQuery)),
      body: FutureBuilder<List<_FoodItem>>(
        future: _foodItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No matching food items found.'));
          }

          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final food = items[index];
              return ListTile(
                title: Text(food.name),
                subtitle: Text('ID: ${food.id}'),
                onTap: () async {
                  final nutrients = await apiGetter.fetchNutrientById(food.id);
                  final selected = SelectedFood(name: food.name, nutrients: nutrients);
                  Navigator.pop(context, selected);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _FoodItem {
  final int id;
  final String name;

  _FoodItem({required this.id, required this.name});
}
