import 'package:flutter_test/flutter_test.dart';
import 'package:prepster/model/entities/pantry_item.dart';
import 'package:prepster/model/repositories/pantry_repository.dart';

// Test for dummy-repository
// Since this class is only a dummy atm, we can't test more than
// the return-types and if the methods can be called without crashing.
// The tests will be updated once the "real" methods have been implemented.

void main() {

  group('PantryRepository Tests', () {
    late PantryRepository pantryRepo;

    setUp(() {
      pantryRepo = PantryRepository();
    });


    // Test only checks if the method completes
    test('Calling addItem prints a message', () async {
      final newItem = PantryItem(name: 'Banana');
      expect(pantryRepo.addItem(newItem), completes);
    });


    // This should return an empty list, as we still can't add any items.
    test('Calling getAllItems returns an empty list and prints a message', () async {
      final items = await pantryRepo.getAllItems();
      expect(items, isEmpty);
    });


    // Checks if the returned item is a PantryItem
    test('Calling getItem with a name returns a PantryItem and prints a message', () async {
      const itemName = 'Apple';
      final item = await pantryRepo.getItem(itemName);
      expect(item, isA<PantryItem>());
      expect(item.name, itemName);
      expect(item.expirationDate, isNotNull); // The dummy returns DateTime.now()
    });


    // Test only checks if the method completes, with some variations
    test('Calling updateItem completes without error', () async {
      await pantryRepo.updateItem(name: 'Milk');
      await pantryRepo.updateItem(name: 'Milk', excludeFromDateTracker: true);
      await pantryRepo.updateItem(name: 'Milk', calories100g: 150.5);
      await pantryRepo.updateItem(name: 'Milk', expirationDate: DateTime.now().add(Duration(days: 2)));
    });


    // Test only checks if the method completes, since there's nothing to delete.
    test('Calling deleteItem completes without error', () async {
      const itemName = 'Orange';
      await pantryRepo.deleteItem(itemName);
    });
  });
}