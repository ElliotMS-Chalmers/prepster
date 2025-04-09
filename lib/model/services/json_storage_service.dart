import 'dart:convert';
import 'dart:io';
import 'package:prepster/model/entities/pantry_item.dart';
import 'package:path/path.dart' as path;

class JsonStorageService {
  // Define the path to our test JSON file
  final String _testFilePath = path.join(
    Directory.current.path,
    'test',
    'model',
    'database',
    'pantry_data_test.json',
  );

  Future<List<dynamic>> _readPantryList() async {
    final File testFile = File(_testFilePath);
    String contents = await testFile.readAsString();
    if (contents.isEmpty) {
      return [];
    }
    return jsonDecode(contents);
  }

  Future<void> _savePantryList(List<dynamic> pantryList) async {
    final File testFile = File(_testFilePath);
    await testFile.writeAsString(jsonEncode(pantryList));
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
      print('Item "${newItem.name}" added to $_testFilePath');
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