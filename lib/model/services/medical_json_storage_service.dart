import 'dart:convert';
import 'dart:io';
import 'package:prepster/model/entities/medical_item.dart';
import 'package:prepster/model/entities/pantry_item.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:prepster/model/services/json_storage_service.dart';
import 'package:prepster/utils/logger.dart';

// File path for json on emulated device:
// /data/data/com.example.prepster/app_flutter/pantry_data.json

class MedicalJsonStorageService implements JsonStorageService<MedicalItem>{

  MedicalJsonStorageService._internal();
  static final MedicalJsonStorageService instance = MedicalJsonStorageService._internal();
  
  final String _medicalFileName = 'medical_data.json';

  Future<File> _getMedicalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, _medicalFileName);
    return File(filePath);
  }

  Future<Map<String, dynamic>> _readMedicalMap() async {
    final file = await _getMedicalFile();
    try {
      final contents = await file.readAsString();
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
    final file = await _getMedicalFile();
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(medicalMap));
  }

  @override
  Future<void> addItem(MedicalItem newItem) async {
    final medicalMap = await _readMedicalMap();
    final newItemJson = newItem.toJson(); // Convert PantryItem to JSON
    medicalMap[newItem.id] = newItemJson; // Add to the map with UUID as key
    await _saveMedicalMap(medicalMap);
    logger.i('Item "${newItem.name}" with ID "${newItem.id}" added to $_medicalFileName');
  }

  @override
  Future<List<MedicalItem>> getAllItems() async {
    final medicalMap = await _readMedicalMap();
    final List<MedicalItem> allItemsList = medicalMap.values
        .map((itemJson) => MedicalItem.fromJson(itemJson as Map<String, dynamic>))
        .toList();
    return allItemsList;
  }

  Future<MedicalItem?> getItem(String itemId) async {
    final medicalMap = await _readMedicalMap();
    final itemJson = medicalMap[itemId];
    if (itemJson != null) {
      return MedicalItem.fromJson(itemJson);
    }
    return null;
  }

  @override
  Future<void> updateItem(String id, MedicalItem updatedItem) async {
    final medicalMap = await _readMedicalMap();
    if (medicalMap.containsKey(id)) {
      final updatedItemJson = updatedItem.toJson(); // Convert the updated item to JSON
      medicalMap[id] = updatedItemJson; // Update the value for the given ID
      await _saveMedicalMap(medicalMap);
      logger.i('Item with ID "$id" updated in $_medicalFileName');
    } else {
      logger.w('Item with ID "$id" not found in $_medicalFileName. Update failed.');
      // You might want to throw an error or handle this case differently
    }
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