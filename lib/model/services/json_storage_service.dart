import 'dart:convert';
import 'dart:io';
import 'package:prepster/model/entities/pantry_item.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class JsonStorageService {
  // Define the path to our test JSON file
  // Define the name of our pantry data file
  final String _pantryFileName = 'pantry_data.json';

  // Method to get the path to our pantry data file in the app's documents directory
  Future<File> _getPantryFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = path.join(directory.path, _pantryFileName);
    return File(filePath);
  }

  Future<List<dynamic>> _readPantryList() async {
    final file = await _getPantryFile();
    try {
      final contents = await file.readAsString();
      if (contents.isEmpty) {
        return [];
      }
      return jsonDecode(contents);
    } catch (e) {
      // If the file doesn't exist yet, return an empty list
      return [];
    }
  }

  Future<void> _savePantryList(List<dynamic> pantryList) async {
    final file = await _getPantryFile();
    // Create the file and any necessary parent directories
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    await file.writeAsString(jsonEncode(pantryList));
  }

  Future<void> addItem(PantryItem newItem) async {
    List<dynamic> pantryList = await _readPantryList();

    // Check if an item with the same name already exists
    bool alreadyExists = false;
    for (var item in pantryList) {
      if (item['name'] == newItem.name) {
        alreadyExists = true;
        break;
      }
    }

    if (alreadyExists) {
      print('Item with name "${newItem.name}" already exists!');
      return;
    }else {
      // If the item doesn't exist, then add it
      Map<String, dynamic> newItemJson = newItem.toJson();
      pantryList.add(newItemJson);
      await _savePantryList(pantryList);
      print('Item "${newItem.name}" added to $_pantryFileName');
    }
  }

  Future<PantryItem?> getItem(String name) async {
    List<dynamic> pantryList = await _readPantryList();

    for (var itemJson in pantryList) {
      if (itemJson['name'] == name) {
        return PantryItem.fromJson(itemJson);
      }
    }

    return null;
  }

  Future<List<PantryItem>> getAllItems() async {
    List<dynamic> jsonData = await _readPantryList();
    return jsonData.map((itemJson) => PantryItem.fromJson(itemJson)).toList();
  }

  Future<String> deleteItem(PantryItem itemToDelete) async {
    List<dynamic> pantryList = await _readPantryList();
    int indexToDelete = -1;
    for (int i = 0; i < pantryList.length; i++) {
      if (pantryList[i]['name'] == itemToDelete.name) {
        indexToDelete = i;
        break;
      }
    }

    if (indexToDelete == -1) {
      return 'Item with name "${itemToDelete.name}" does not exist!';
    }

    pantryList.removeAt(indexToDelete);
    await _savePantryList(pantryList);
    return 'Item "${itemToDelete.name}" deleted successfully!';
  }
}