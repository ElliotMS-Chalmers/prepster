import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepster/model/entities/medical_item.dart';
import 'package:prepster/model/services/medical_json_storage_service.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;


const String _medicalFileName = 'test/model/database/medical_data_test.json';

class MockMedicalJsonStorageService extends Mock implements MedicalJsonStorageService {
  final String _testFilePath = path.join(
    Directory.current.path,
    'test',
    'model',
    'database',
    'medical_data_test.json',
  );

  Future<Map<String, dynamic>> _readMedicalMap() async {
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

  Future<void> _saveMedicalMap(Map<String, dynamic> medicalMap) async {
    final File testFile = File(_testFilePath);
    await testFile.writeAsString(jsonEncode(medicalMap));
  }

  @override
  Future<String> addItem(MedicalItem newItem) async {
    final medicalMap = await _readMedicalMap();
    final newItemJson = newItem.toJson();

    medicalMap[newItem.id] = newItemJson;
    await _saveMedicalMap(medicalMap);
    print(
      'Item "${newItem.name}" with ID "${newItem.id}" added to $_testFilePath',
    );
    return newItem.id;
  }

  @override
  Future<List<MedicalItem>> getAllItems() async {
    final medicalMap = await _readMedicalMap();
    final List<MedicalItem> allItemsList =
    medicalMap.values
        .map(
          (itemJson) =>
          MedicalItem.fromJson(itemJson as Map<String, dynamic>),
    )
        .toList();
    return allItemsList;
  }

  @override
  Future<MedicalItem?> getItem(String itemId) async {
    final medicalMap = await _readMedicalMap();
    final itemJson = medicalMap[itemId];
    if (itemJson != null) {
      return MedicalItem.fromJson(itemJson);
    }
    return null;
  }

  @override
  Future<String> deleteItem(String idToDelete) async {
    final medicalMap = await _readMedicalMap();
    if (medicalMap.containsKey(idToDelete)) {
      // Only necessary to get the itemName for the success message
      final itemName = medicalMap[idToDelete]['name'];
      medicalMap.remove(idToDelete);
      await _saveMedicalMap(medicalMap);
      return 'Item "$itemName" with ID "$idToDelete" deleted successfully!';
    } else {
      return 'Item with ID "$idToDelete" does not exist!';
    }
  }
}

void main() {
  group('JsonStorageService Tests', () {
    final MockMedicalJsonStorageService medicalStorageService =
    MockMedicalJsonStorageService();
    late File testFile;

    setUp(() async {
      testFile = File(_medicalFileName);
      // Ensure the test file exists and is empty before each test.
      if (await testFile.exists()) {
        await testFile.delete();
      }
      await testFile.create(recursive: true);
      // Write the initial JSON data to the file.
      final initialData = {
        'paracetamol-id': {
          'id': 'paracetamol-id',
          'name': 'Paracetamol',
          'amount': 24,
          "expirationDate": "2026-05-23T00:00:00.000",
          "excludeFromDateTracker": false
        },
        'ibuprofen-id': {
          'id': 'ibuprofen-id',
          'name': 'Ibuprofen',
          'amount': 10,
          "expirationDate": "2026-05-23T00:00:00.000",
          "excludeFromDateTracker": false
        },
      };
      await testFile.writeAsString(jsonEncode(initialData));
    });

    test('addItem() should add a MedicalItem to the JSON file', () async {
      final newBandage = MedicalItem(
        id: 'bandage-id',
        name: 'Bandage',
        amount: 4,
        expirationDate: null,
        excludeFromDateTracker: true,
      );

      final expectedJson = {
        'paracetamol-id': {
          'id': 'paracetamol-id',
          'name': 'Paracetamol',
          'amount': 24,
          "expirationDate": "2026-05-23T00:00:00.000",
          "excludeFromDateTracker": false
        },
        'ibuprofen-id': {
          'id': 'ibuprofen-id',
          'name': 'Ibuprofen',
          'amount': 10,
          "expirationDate": "2026-05-23T00:00:00.000",
          "excludeFromDateTracker": false
        },
        'bandage-id': {
          'id': 'bandage-id',
          'name': 'Bandage',
          'amount': 4,
          "expirationDate": null,
          "excludeFromDateTracker": true
        }
      };

      await medicalStorageService.addItem(newBandage);
      final fileContents = await testFile.readAsString();
      final decodedJson = jsonDecode(fileContents);
      expect(decodedJson, expectedJson);
    });

    test(
      'getAllItems() should return a list of the entire JSON file',
          () async {
        final List<MedicalItem> actualItems = await medicalStorageService.getAllItems();
        final expectedItems = [
          MedicalItem(
            id: 'paracetamol-id',
            name: 'Paracetamol',
            amount: 24,
            expirationDate: DateTime(2026, 05, 23),
            excludeFromDateTracker: false,
          ),
          MedicalItem(
            id: 'ibuprofen-id',
            name: 'Ibuprofen',
            amount: 10,
            expirationDate: DateTime(2026, 05, 23),
            excludeFromDateTracker: false,
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
        MedicalItem? returnedObject = await medicalStorageService.getItem('paracetamol-id');
        final expectedJson = MedicalItem(
          id: 'paracetamol-id',
          name: 'Paracetamol',
          amount: 24,
          expirationDate: DateTime(2026, 05, 23),
          excludeFromDateTracker: false,
        );
        expect(returnedObject?.toJson(), expectedJson.toJson());
      },
    );

    test('deleteItem() should delete a MedicalItem to the JSON file', () async {
      final expectedJson = {
        'paracetamol-id': {
          'id': 'paracetamol-id',
          'name': 'Paracetamol',
          'amount': 24,
          "expirationDate": "2026-05-23T00:00:00.000",
          "excludeFromDateTracker": false
        },
      };
      await medicalStorageService.deleteItem('ibuprofen-id');
      final fileContents = await testFile.readAsString();
      final decodedJson = jsonDecode(fileContents);
      expect(decodedJson, expectedJson);
    });
  });
}
