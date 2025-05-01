import 'dart:convert';
import 'dart:io';
import 'package:prepster/model/entities/equipment_item.dart';
import 'package:prepster/model/entities/pantry_item.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:prepster/model/services/json_storage_service.dart';
import 'package:prepster/utils/logger.dart';

// File path for json on emulated device:
// /data/data/com.example.prepster/app_flutter/pantry_data.json

class EquipmentJsonStorageService implements JsonStorageService<EquipmentItem>{

  EquipmentJsonStorageService._internal();
  static final EquipmentJsonStorageService instance = EquipmentJsonStorageService._internal();
  
  final String _equipmentFileName = 'equipment_data.json';

  Future<File> _getEquipmentFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, _equipmentFileName);
    return File(filePath);
  }

  Future<Map<String, dynamic>> _readEquipmentMap() async {
    final file = await _getEquipmentFile();
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

  Future<void> _saveEquipmentMap(Map<String, dynamic> equipmentMap) async {
    final file = await _getEquipmentFile();
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(equipmentMap));
  }

  @override
  Future<void> addItem(EquipmentItem newItem) async {
    final equipmentMap = await _readEquipmentMap();
    final newItemJson = newItem.toJson(); // Convert PantryItem to JSON
    equipmentMap[newItem.id] = newItemJson; // Add to the map with UUID as key
    await _saveEquipmentMap(equipmentMap);
    logger.i('Item "${newItem.name}" with ID "${newItem.id}" added to $_equipmentFileName');
  }

  @override
  Future<List<EquipmentItem>> getAllItems() async {
    final equipmentMap = await _readEquipmentMap();
    final List<EquipmentItem> allItemsList = equipmentMap.values
        .map((itemJson) => EquipmentItem.fromJson(itemJson as Map<String, dynamic>))
        .toList();
    return allItemsList;
  }

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