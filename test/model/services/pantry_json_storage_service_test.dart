import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepster/model/entities/pantry_item.dart';
import 'package:prepster/model/services/pantry_json_storage_service.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;

const String _pantryFileName = 'test/model/database/pantry_data_test.json';

class MockPantryJsonStorageService extends Mock implements PantryJsonStorageService {
  final String _testFilePath = path.join(
    Directory.current.path,
    'test',
    'model',
    'database',
    'pantry_data_test.json',
  );

  Future<Map<String, dynamic>> _readPantryMap() async {
    final File testFile = File(_testFilePath);
    try {
      final contents = await testFile.readAsString();
      if (contents.isEmpty) {
        return {}; // Return an empty map if the file is empty
      }
      return jsonDecode(contents) as Map<String, dynamic>; // Decode as a map
    } catch (e) {
      // If the file doesn't exist yet, return an empty map
      return {};
    }
  }

  Future<void> _savePantryMap(Map<String, dynamic> pantryMap) async {
    final File testFile = File(_testFilePath);
    await testFile.writeAsString(jsonEncode(pantryMap));
  }

  @override
  Future<String> addItem(PantryItem newItem) async {
    final pantryMap = await _readPantryMap();
    final newItemJson = newItem.toJson();

    pantryMap[newItem.id] = newItemJson;
    await _savePantryMap(pantryMap);
    print(
      'Item "${newItem.name}" with ID "${newItem.id}" added to $_testFilePath',
    );
    return newItem.id;
  }

  @override
  Future<List<PantryItem>> getAllItems() async {
    final pantryMap = await _readPantryMap();
    final List<PantryItem> allItemsList =
    pantryMap.values
        .map(
          (itemJson) =>
          PantryItem.fromJson(itemJson as Map<String, dynamic>),
    )
        .toList();
    return allItemsList;
  }

  @override
  Future<PantryItem?> getItem(String itemId) async {
    final pantryMap = await _readPantryMap();
    final itemJson = pantryMap[itemId];
    if (itemJson != null) {
      return PantryItem.fromJson(itemJson);
    }
    return null;
  }

  @override
  Future<String> deleteItem(String idToDelete) async {
    final pantryMap = await _readPantryMap();
    if (pantryMap.containsKey(idToDelete)) {
      // Only necessary to get the itemName for the success message
      final itemName = pantryMap[idToDelete]['name'];
      pantryMap.remove(idToDelete);
      await _savePantryMap(pantryMap);
      return 'Item "$itemName" with ID "$idToDelete" deleted successfully!';
    } else {
      return 'Item with ID "$idToDelete" does not exist!';
    }
  }
}

void main() {
  group('JsonStorageService Tests', () {
    final MockPantryJsonStorageService pantryStorageService =
    MockPantryJsonStorageService();
    late File testFile;

    setUp(() async {
      testFile = File(_pantryFileName);
      // Ensure the test file exists and is empty before each test.
      if (await testFile.exists()) {
        await testFile.delete();
      }
      await testFile.create(recursive: true);
      // Write the initial JSON data to the file.
      final initialData = {
        'apple-id': {
          'id': 'apple-id',
          'name': 'Apple',
          'amount': 5,
          'expirationDate': DateTime(2025, 1, 1).toIso8601String(),
          'calories100g': 52.0,
          'weightKg': 0.5,
          'categories': {
            'carbohydrate': 20.0,
            'fat': 0.0,
            'protein': 0.0,
          },
          'excludeFromDateTracker': false,
          'excludeFromCaloriesTracker': false,
        },
        'banana-id': {
          'id': 'banana-id',
          'name': 'Banana',
          'amount': 5,
          'expirationDate': DateTime(2025, 1, 1).toIso8601String(),
          'calories100g': 52.0,
          'weightKg': 0.5,
          'categories': {
            'carbohydrate': 50.0,
            'fat': 0.0,
            'protein': 0.0,
          },
          'excludeFromDateTracker': false,
          'excludeFromCaloriesTracker': false,
        },
      };
      await testFile.writeAsString(jsonEncode(initialData));
    });

    test('addItem() should add a PantryItem to the JSON file', () async {
      final newToiletPaper = PantryItem(
        id: 'toilet-paper-id',
        name: 'Toilet Paper',
        amount: 5,
        expirationDate: null,
        calories100g: 0.0,
        weightKg: 0.5,
        categories: {
          FoodCategory.carbohydrate: 0.0,
          FoodCategory.fat: 0.0,
          FoodCategory.protein: 0.0,
        },
        excludeFromDateTracker: true,
        excludeFromCaloriesTracker: true,
      );

      final expectedJson = {
        'apple-id': {
          'id': 'apple-id',
          'name': 'Apple',
          'amount': 5,
          'expirationDate': DateTime(2025, 1, 1).toIso8601String(),
          'calories100g': 52.0,
          'weightKg': 0.5,
          'categories': {
            'carbohydrate': 20.0,
            'fat': 0.0,
            'protein': 0.0,
          },
          'excludeFromDateTracker': false,
          'excludeFromCaloriesTracker': false,
        },
        'banana-id': {
          'id': 'banana-id',
          'name': 'Banana',
          'amount': 5,
          'expirationDate': DateTime(2025, 1, 1).toIso8601String(),
          'calories100g': 52.0,
          'weightKg': 0.5,
          'categories': {
            'carbohydrate': 50.0,
            'fat': 0.0,
            'protein': 0.0,
          },
          'excludeFromDateTracker': false,
          'excludeFromCaloriesTracker': false,
        },
        'toilet-paper-id': {
          'id': 'toilet-paper-id',
          'name': 'Toilet Paper',
          'amount': 5,
          'expirationDate': null,
          'calories100g': 0.0,
          'weightKg': 0.5,
          'categories': {
            'carbohydrate': 0.0,
            'fat': 0.0,
            'protein': 0.0,
          },
          'excludeFromDateTracker': true,
          'excludeFromCaloriesTracker': true,
        },
      };

      await pantryStorageService.addItem(newToiletPaper);
      final fileContents = await testFile.readAsString();
      final decodedJson = jsonDecode(fileContents);
      expect(decodedJson, expectedJson);
    });

    test(
      'getAllItems() should return a list of the entire JSON file',
          () async {
        final List<PantryItem> actualItems = await pantryStorageService.getAllItems();
        final expectedItems = [
          PantryItem(
            id: 'apple-id',
            name: 'Apple',
            amount: 5,
            expirationDate: DateTime(2025, 1, 1),
            calories100g: 52.0,
            weightKg: 0.5,
            categories: {
              FoodCategory.carbohydrate: 20.0,
              FoodCategory.fat: 0.0,
              FoodCategory.protein: 0.0,
            },
            excludeFromDateTracker: false,
            excludeFromCaloriesTracker: false,
          ),
          PantryItem(
            id: 'banana-id',
            name: 'Banana',
            amount: 5,
            expirationDate: DateTime(2025, 1, 1),
            calories100g: 52.0,
            weightKg: 0.5,
            categories: {
              FoodCategory.carbohydrate: 50.0,
              FoodCategory.fat: 0.0,
              FoodCategory.protein: 0.0,
            },
            excludeFromDateTracker: false,
            excludeFromCaloriesTracker: false,
          ),
        ];
        expect(actualItems.length, expectedItems.length);
        for (var i = 0; i < actualItems.length; i++) {
          expect(actualItems[i].toJson(), expectedItems[i].toJson());
        }
      },
    );

    test(
      'getItem(id) should return the object associated with the id',
          () async {
        PantryItem? returnedObject = await pantryStorageService.getItem('apple-id');
        final expectedJson = PantryItem(
          id: 'apple-id',
          name: 'Apple',
          amount: 5,
          expirationDate: DateTime(2025, 1, 1),
          calories100g: 52.0,
          weightKg: 0.5,
          categories: {
            FoodCategory.carbohydrate: 20.0,
            FoodCategory.fat: 0.0,
            FoodCategory.protein: 0.0,
          },
          excludeFromDateTracker: false,
          excludeFromCaloriesTracker: false,
        );
        expect(returnedObject?.toJson(), expectedJson.toJson());
      },
    );

    test('deleteItem() should delete a PantryItem to the JSON file', () async {
      final expectedJson = {
        'banana-id': {
          'id': 'banana-id',
          'name': 'Banana',
          'amount': 5,
          'expirationDate': DateTime(2025, 1, 1).toIso8601String(),
          'calories100g': 52.0,
          'weightKg': 0.5,
          'categories': {
            'carbohydrate': 50.0,
            'fat': 0.0,
            'protein': 0.0,
          },
          'excludeFromDateTracker': false,
          'excludeFromCaloriesTracker': false,
        },
      };
      await pantryStorageService.deleteItem('apple-id');
      final fileContents = await testFile.readAsString();
      final decodedJson = jsonDecode(fileContents);
      expect(decodedJson, expectedJson);
    });
  });
}
