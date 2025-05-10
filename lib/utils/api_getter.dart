import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:prepster/model/repositories/settings_repository.dart';
import 'package:prepster/model/services/settings_service.dart';


class ApiGetter {

  Future<int> fetchLanguage() async {
    SettingsRepository settings = SettingsRepository(SettingsService.instance);
    String language = await settings.getSelectedLanguage() ?? settings.getFallbackLanguage();
    if (language == 'sv') {
      return 1;
    } else {
      return 2;
    }
  }

  Future<String> fetchFoodById(int id) async {
    final url = Uri.parse('https://dataportal.livsmedelsverket.se/livsmedel/api/v1/livsmedel/$id?sprak=${await fetchLanguage()}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['namn'];
    } else {
      throw Exception('Failed to fetch food by ID');
    }
  }

  Future<Map<String, double?>> fetchNutrientById(int id) async {
    final url = Uri.parse('https://dataportal.livsmedelsverket.se/livsmedel/api/v1/livsmedel/$id/naringsvarden?sprak=${await fetchLanguage()}');
    final Map<String, double?> result = {};
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      for (var item in data) {
        if (await fetchLanguage() == 1) {
          if (item['namn'] == 'Energi (kcal)') {
            result['Energi'] = item['varde'].toDouble();
          } else if (item['namn'] == 'Fett, totalt') {
            result['Fett'] = item['varde'];
          } else if (item['namn'] == 'Kolhydrater, tillgängliga') {
            result['Kolhydrater'] = item['varde'];
          } else if (item['namn'] == 'Protein') {
            result['Protein'] = item['varde'];
          }
        } else {
          if (item['namn'] == 'Energy (kcal)') {
            result['Energi'] = item['varde'].toDouble();
          } else if (item['namn'] == 'Fat, total') {
            result['Fett'] = item['varde'];
          } else if (item['namn'] == 'Carbohydrates, available') {
            result['Kolhydrater'] = item['varde'];
          } else if (item['namn'] == 'Protein') {
            result['Protein'] = item['varde'];
          }
        }
      }
    } else {
      throw Exception('Failed to fetch food by ID');
    }
    return result;
  }
    // Function to search food by name and return its ID
  Future<List<int>> fetchFoodIdsByName(String foodName) async {
    int limit = 2500; // returns all items
    final url = Uri.parse(
        'https://dataportal.livsmedelsverket.se/livsmedel/api/v1/livsmedel?limit=$limit&sprak=${await fetchLanguage()}');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch food data');
    }

    final data = json.decode(response.body);
    final List<dynamic> foodList = data["livsmedel"];

    List<int> matchingIds = [];

    // Lowercase and split search terms
    final searchWords = foodName.toLowerCase().split(' ');

    for (var item in foodList) {
      final name = (item["namn"] as String).toLowerCase();
      final nameWords = name.split(RegExp(r'\s+')); // Split on any whitespace

      // Check that all search words match whole words in the name
      final allWordsMatch = searchWords.every((word) => nameWords.contains(word));

      if (allWordsMatch) {
        final foodId = item["nummer"] as int;
        matchingIds.add(foodId);
      }
    }

    if (matchingIds.isEmpty) {
      throw Exception('No matching food found');
    }

    return matchingIds;
  }
}
