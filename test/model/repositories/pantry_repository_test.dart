/*
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prepster/model/entities/pantry_item.dart';
import 'package:prepster/model/repositories/pantry_repository.dart';
import 'package:uuid/uuid.dart';

class MockPantryRepository extends Mock implements PantryRepository {
  //final _uuid = const Uuid();
  final List<PantryItem> _pantryItems = [];

  Future<PantryItem> addItem({
    required String name,
    DateTime? expirationDate,
    int? amount,
    double? calories100g,
    double? weightKg,
    Map<FoodCategory, double>? categories,
    bool? excludeFromDateTracker,
    bool? excludeFromCaloriesTracker,
  }) async {
    print('Before adding item, the list is: $_pantryItems');

    if (name.length > 50) {
      throw ArgumentError('Name cannot be longer than 50 characters');
    }

    amount ??= 1;

    if (expirationDate == null) {
      excludeFromDateTracker = true;
    }

    if (calories100g == null) {
      excludeFromCaloriesTracker = true;
    }

    // The ??= replaces if-statements to check for null-values
    // If the value isn't null then the value won't be changed
    if (weightKg != null && weightKg.isNegative) {
      throw ArgumentError('Weight cannot be negative');
    }

    categories ??= <FoodCategory, double>{};
    for (var category in FoodCategory.values) {
      categories.putIfAbsent(category, () => 0.0);
    }
    excludeFromDateTracker ??= false;
    excludeFromCaloriesTracker ??= false;

    PantryItem newItem = PantryItem(
      id: Uuid().v4(),
      name: name,
      amount: amount,
      expirationDate: expirationDate,
      calories100g: calories100g,
      weightKg: weightKg,
      categories: categories,
      excludeFromDateTracker: excludeFromDateTracker,
      excludeFromCaloriesTracker: excludeFromCaloriesTracker,
    );
    _pantryItems.add(newItem);
    print('After adding item, the list is: $_pantryItems');
    return newItem;
  }

  Future<List<PantryItem>> getAllItems() async {
    return _pantryItems;
  }

  Future<void> deleteItem<T>(T itemToDelete) async {
    _pantryItems.removeWhere((item) => item.id == itemToDelete);
  }
}

void main() {
  final MockPantryRepository MockRepository = MockPantryRepository();
  List<PantryItem> pantryItems = [];

  setUp(() async {
    print('Moving on to next test...');
    // Clear the list before each test
    // pantryItems.clear();
  });
  tearDown(() {});

  test('[Test] addItem(): valid parameters.', () async {
    PantryItem newApple = await MockRepository.addItem(
      name: 'Apple',
      amount: 3,
      weightKg: 3.0,
      calories100g: 100.0,
      categories: {FoodCategory.carbohydrate: 20.0},
      expirationDate: DateTime(2025 - 05 - 01),
    );

    expect(newApple.name, 'Apple');
    expect(newApple.amount, 3);
    expect(newApple.expirationDate, DateTime(2025 - 05 - 01));
    expect(newApple.calories100g, 100.0);
    expect(newApple.weightKg, 3.0);
    expect(newApple.categories, {
      FoodCategory.carbohydrate: 20.0,
      FoodCategory.fat: 0.0,
      FoodCategory.protein: 0.0,
    });
    expect(newApple.excludeFromDateTracker, false);
    expect(newApple.excludeFromCaloriesTracker, false);
    pantryItems.add(newApple);
    print('AppleId: ${newApple.id}');

    PantryItem newToiletPaper = await MockRepository.addItem(
      name: 'Toilet paper',
      amount: 6,
      weightKg: 0.8,
    );

    expect(newToiletPaper.name, 'Toilet paper');
    expect(newToiletPaper.amount, 6);
    expect(newToiletPaper.expirationDate, null);
    expect(newToiletPaper.calories100g, null);
    expect(newToiletPaper.weightKg, 0.8);
    expect(newToiletPaper.categories, {
      FoodCategory.carbohydrate: 0.0,
      FoodCategory.fat: 0.0,
      FoodCategory.protein: 0.0,
    });
    expect(newToiletPaper.excludeFromDateTracker, true);
    expect(newToiletPaper.excludeFromCaloriesTracker, true);
    pantryItems.add(newToiletPaper);

    print('...');
  });

  test('[Test] addItem(): invalid parameters.', () async {
    expectLater(
      MockRepository.addItem(name: 'Apple', weightKg: -8.0),
      throwsA(isA<ArgumentError>()),
    );
    print('...');
  });

  test('[Test] getAllItems(): reading previously added items ', () async {
    List<PantryItem> retrievedList = await MockRepository.getAllItems();
    expect(retrievedList, pantryItems);
    print('Local list: $pantryItems');
    print('Retrieved list: $retrievedList');
  });

  test('[Test] Deleting "Apple" from PantryItems', () async {
    print('PantryItems before delete: $pantryItems');
    String itemToDeleteId =
        pantryItems.firstWhere((item) => item.name == 'Apple').id;
    await MockRepository.deleteItem(itemToDeleteId);
    List<PantryItem> retrievedList = await MockRepository.getAllItems();
    expect(retrievedList.any((item) => item.name == 'Apple'), false);
    print('PantryItems after delete: $retrievedList');
  });
}
*/