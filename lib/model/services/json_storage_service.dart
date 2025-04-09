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

  Future<void> addItem(PantryItem newItem) async {
    final File testFile = File(_testFilePath);
    String contents = await testFile.readAsString();
    List<dynamic> pantryList = [];
    if (contents.isNotEmpty) {
      pantryList = jsonDecode(contents);
    }

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
    }

    // If the item doesn't exist, then add it
    Map<String, dynamic> newItemJson = newItem.toJson();
    pantryList.add(newItemJson);
    await testFile.writeAsString(jsonEncode(pantryList));
    print('Item "${newItem.name}" added to $_testFilePath');
  }

  Future<String> deleteItem(PantryItem itemToDelete) async {
    final File testFile = File(_testFilePath);
    String contents = await testFile.readAsString();
    List<dynamic> pantryList = [];
    if (contents.isNotEmpty) {
      pantryList = jsonDecode(contents);
    }

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

    // If the item exists, then delete it using its index
    pantryList.removeAt(indexToDelete);
    await testFile.writeAsString(jsonEncode(pantryList));
    return 'Item "${itemToDelete.name}" deleted successfully!';
  }
}