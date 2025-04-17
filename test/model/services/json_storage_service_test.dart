import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepster/model/entities/pantry_item.dart';
import 'package:prepster/model/services/json_storage_service.dart';
import 'package:path/path.dart' as path;

// Helper function to get the test file path
String _getTestFilePath() {
  return path.join(
    Directory.current.path,
    'test',
    'model',
    'database',
    'pantry_data_test.json',
  );
}


// Helper function to clear the test file before each test
Future<void> _clearTestFile() async {
  final testFilePath = _getTestFilePath();
  final File testFile = File(testFilePath);
  if (await testFile.exists()) {
    await testFile.writeAsString('[]');
  } else {
    await testFile.create();
    await testFile.writeAsString('[]');
  }
}


late String testFilePath;
late File testFile;
late JsonStorageService storageService;


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    testFilePath = _getTestFilePath();
    testFile = File(testFilePath);
    storageService = JsonStorageService();
    await _clearTestFile(); // Tests expect a clean file to start with
  });


  //test('addItem should save a simple PantryItem to the test file', () async {
  //  final apple = PantryItem(name: 'Apple', calories100g: 50.0);
  //  await storageService.addItem(apple);
  //  final fileContents = await testFile.readAsString();
  //  expect(fileContents.contains('Apple'), isTrue);
  //});


  //test('addItem should not add duplicate items', () async {
  //  final banana = PantryItem(name: 'Banana', calories100g: 60.0);
  //  await storageService.addItem(banana);
  //  await storageService.addItem(banana);
  //  final fileContents = await testFile.readAsString();
  //  final List<dynamic> decodedList = jsonDecode(fileContents);
  //  expect(decodedList.length, 1);
  //  expect(decodedList.any((item) => item['name'] == 'Banana'), isTrue);
  //});


  //test('getAllItems should return all PantryItems from the test file', () async {
  //  // Create two PantryItems
  //  final apple = PantryItem(name: 'Apple', calories100g: 50.0);
  //  final banana = PantryItem(name: 'Banana', calories100g: 96.0);
//
  //  // Add them to the file
  //  await storageService.addItem(apple);
  //  await storageService.addItem(banana);
//
  //  // Get all items from the file
  //  final allItems = await storageService.getAllItems();
//
  //  // Expect the list to have a length of 2
  //  expect(allItems.length, 2);
  //  print("####################################");
  //  print(allItems);
  //  print("####################################");
//
  //  // You could also add more specific checks if you want, like:
  //  expect(allItems.any((item) => item.name == 'Apple'), isTrue);
  //  expect(allItems.any((item) => item.calories100g == 50.0), isTrue);
  //  expect(allItems.any((item) => item.name == 'Banana'), isTrue);
  //  expect(allItems.any((item) => item.calories100g == 96.0), isTrue);
  //});


  //test('getItem should return the correct PantryItem by name', () async {
  //  final JsonStorageService storageService = JsonStorageService();
//
  //  // Create and add a test item
  //  final apple = PantryItem(name: 'Apple', calories100g: 50.0);
  //  await storageService.addItem(apple);
//
  //  // Try to get the item by its name
  //  final retrievedItem = await storageService.getItem('Apple');
//
  //  // Check if we got an item back and if its properties are correct
  //  expect(retrievedItem, isNotNull);
  //  expect(retrievedItem?.name, 'Apple');
  //  expect(retrievedItem?.calories100g, 50.0);
  //});

  //test('getItem should return null if the item does not exist', () async {
  //  final JsonStorageService storageService = JsonStorageService();
//
  //  // Try to get an item that hasn't been added
  //  final retrievedItem = await storageService.getItem('Orange');
//
  //  // Check if we got null back
  //  expect(retrievedItem, isNull);
  //});


  //test('deleteItem should remove an existing PantryItem and return a success message', () async {
  //  final itemToDelete = PantryItem(name: 'ToDelete', calories100g: 10.0);
  //  final apple = PantryItem(name: 'Apple', calories100g: 50.0);
  //  await storageService.addItem(itemToDelete);
  //  await storageService.addItem(apple);
  //  final result = await storageService.deleteItem(itemToDelete);
  //  expect(result, 'Item "ToDelete" deleted successfully!');
  //  final fileContents = await testFile.readAsString();
  //  expect(fileContents.contains('ToDelete'), isFalse);
//
  //  // Check that no other items were deleted
  //  expect(fileContents.contains('Apple'), isTrue);
  //});


  //test('deleteItem should return a "not found" message when trying to delete a non-existent item', () async {
  //  final nonExistentItem = PantryItem(name: 'NotThere', calories100g: 99.0);
  //  final result = await storageService.deleteItem(nonExistentItem);
  //  expect(result, 'Item with name "NotThere" does not exist!');
  //  final fileContents = await testFile.readAsString();
  //  expect(fileContents, '[]');
  //});
}