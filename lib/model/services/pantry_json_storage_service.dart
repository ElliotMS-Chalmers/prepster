import 'dart:convert';
import 'dart:io';
import 'package:prepster/model/entities/pantry_item.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:prepster/model/services/json_storage_service.dart';
import 'package:prepster/utils/logger.dart';

// File path for json on emulated device:
// /data/data/com.example.prepster/app_flutter/pantry_data.json

class PantryJsonStorageService implements JsonStorageService<PantryItem>{
  PantryJsonStorageService._internal();
  static final PantryJsonStorageService instance = PantryJsonStorageService._internal();
  
  final String _pantryFileName = 'pantry_data.json';

  Future<File> _getPantryFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, _pantryFileName);
    return File(filePath);
  }

  Future<Map<String, dynamic>> _readPantryMap() async {
    final file = await _getPantryFile();
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

  Future<void> _savePantryMap(Map<String, dynamic> pantryMap) async {
    final file = await _getPantryFile();
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    await file.writeAsString(const JsonEncoder.withIndent('  ').convert(pantryMap));
  }

  @override
  Future<void> addItem(PantryItem newItem) async {
    final pantryMap = await _readPantryMap();
    final newItemJson = newItem.toJson(); // Convert PantryItem to JSON
    pantryMap[newItem.id] = newItemJson; // Add to the map with UUID as key
    await _savePantryMap(pantryMap);
    logger.i('Item "${newItem.name}" with ID "${newItem.id}" added to $_pantryFileName');
  }

  @override
  Future<List<PantryItem>> getAllItems() async {
    final pantryMap = await _readPantryMap();
    final List<PantryItem> allItemsList = pantryMap.values
        .map((itemJson) => PantryItem.fromJson(itemJson as Map<String, dynamic>))
        .toList();
    return allItemsList;
  }

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