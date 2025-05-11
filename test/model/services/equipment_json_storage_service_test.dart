import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepster/model/entities/equipment_item.dart';
import 'package:prepster/model/services/equipment_json_storage_service.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;

const String _equipmentFileName = 'test/model/database/equipment_data_test.json';

class MockEquipmentJsonStorageService extends Mock implements EquipmentJsonStorageService {
  final String _testFilePath = path.join(
    Directory.current.path,
    'test',
    'model',
    'database',
    'equipment_data_test.json',
  );

  Future<Map<String, dynamic>> _readEquipmentMap() async {
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

  Future<void> _saveEquipmentMap(Map<String, dynamic> equipmentMap) async {
    final File testFile = File(_testFilePath);
    await testFile.writeAsString(jsonEncode(equipmentMap));
  }

  @override
  Future<String> addItem(EquipmentItem newItem) async {
    final equipmentMap = await _readEquipmentMap();
    final newItemJson = newItem.toJson();

    equipmentMap[newItem.id] = newItemJson;
    await _saveEquipmentMap(equipmentMap);
    print(
      'Item "${newItem.name}" with ID "${newItem.id}" added to $_testFilePath',
    );
    return newItem.id;
  }

  @override
  Future<List<EquipmentItem>> getAllItems() async {
    final equipmentMap = await _readEquipmentMap();
    final List<EquipmentItem> allItemsList =
    equipmentMap.values
        .map(
          (itemJson) =>
          EquipmentItem.fromJson(itemJson as Map<String, dynamic>),
    )
        .toList();
    return allItemsList;
  }

  @override
  Future<EquipmentItem?> getItem(String itemId) async {
    final equipmentMap = await _readEquipmentMap();
    final itemJson = equipmentMap[itemId];
    if (itemJson != null) {
      return EquipmentItem.fromJson(itemJson);
    }
    return null;
  }

  @override
  Future<String> deleteItem(String idToDelete) async {
    final equipmentMap = await _readEquipmentMap();
    if (equipmentMap.containsKey(idToDelete)) {
      // Only necessary to get the itemName for the success message
      final itemName = equipmentMap[idToDelete]['name'];
      equipmentMap.remove(idToDelete);
      await _saveEquipmentMap(equipmentMap);
      return 'Item "$itemName" with ID "$idToDelete" deleted successfully!';
    } else {
      return 'Item with ID "$idToDelete" does not exist!';
    }
  }
}

void main() {
  group('JsonStorageService Tests', () {
    final MockEquipmentJsonStorageService equipmentStorageService =
    MockEquipmentJsonStorageService();
    late File testFile;

    setUp(() async {
      testFile = File(_equipmentFileName);
      // Ensure the test file exists and is empty before each test.
      if (await testFile.exists()) {
        await testFile.delete();
      }
      await testFile.create(recursive: true);
      // Write the initial JSON data to the file.
      final initialData = {
        'vevradio-id': {
          'id': 'vevradio-id',
          'name': 'Vevradio',
          'amount': 1,
          "expirationDate": null,
          "excludeFromDateTracker": true
        },
        'kniv-id': {
          'id': 'kniv-id',
          'name': 'Kniv',
          'amount': 2,
          "expirationDate": null,
          "excludeFromDateTracker": true
        },
      };
      await testFile.writeAsString(jsonEncode(initialData));
    });

    test('addItem() should add a EquipmentItem to the JSON file', () async {
      final newVinkelslip = EquipmentItem(
        id: 'vinkelslip-id',
        name: 'Vinkelslip',
        amount: 1,
        excludeFromDateTracker: true,
      );

      final expectedJson = {
        'vevradio-id': {
          'id': 'vevradio-id',
          'name': 'Vevradio',
          'amount': 1,
          "expirationDate": null,
          "excludeFromDateTracker": true
        },
        'kniv-id': {
          'id': 'kniv-id',
          'name': 'Kniv',
          'amount': 2,
          "expirationDate": null,
          "excludeFromDateTracker": true
        },
        'vinkelslip-id': {
          'id': 'vinkelslip-id',
          'name': 'Vinkelslip',
          'amount': 1,
          "expirationDate": null,
          "excludeFromDateTracker": true
        }
      };

      await equipmentStorageService.addItem(newVinkelslip);
      final fileContents = await testFile.readAsString();
      final decodedJson = jsonDecode(fileContents);
      expect(decodedJson, expectedJson);
    });

    test(
      'getAllItems() should return a list of the entire JSON file',
          () async {
        final List<EquipmentItem> actualItems = await equipmentStorageService.getAllItems();
        final expectedItems = [
          EquipmentItem(
            id: 'vevradio-id',
            name: 'Vevradio',
            amount: 1,
            excludeFromDateTracker: true,
          ),
          EquipmentItem(
            id: 'kniv-id',
            name: 'Kniv',
            amount: 2,
            excludeFromDateTracker: true,
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
        EquipmentItem? returnedObject = await equipmentStorageService.getItem('vevradio-id');
        final expectedJson = EquipmentItem(
          id: 'vevradio-id',
          name: 'Vevradio',
          amount: 1,
          expirationDate: null,
          excludeFromDateTracker: true,
        );
        expect(returnedObject?.toJson(), expectedJson.toJson());
      },
    );

    test('deleteItem() should delete a EquipmentItem to the JSON file', () async {
      final expectedJson = {
        'kniv-id': {
          'id': 'kniv-id',
          'name': 'Kniv',
          'amount': 2,
          "expirationDate": null,
          "excludeFromDateTracker": true
        },
      };
      await equipmentStorageService.deleteItem('vevradio-id');
      final fileContents = await testFile.readAsString();
      final decodedJson = jsonDecode(fileContents);
      expect(decodedJson, expectedJson);
    });
  });
}
