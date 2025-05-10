import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prepster/model/entities/pantry_item.dart';
import 'package:prepster/model/entities/medical_item.dart';
import 'package:prepster/model/entities/equipment_item.dart';
import 'package:prepster/model/entities/inventory_item.dart';
import 'package:prepster/model/repositories/inventory_repository.dart';
import 'package:prepster/utils/default_settings.dart';
import 'mockups/mock_json_storage_service.mocks.dart';
import 'package:logger/logger.dart';

void main() {

  Logger.level = Level.off;

  TestWidgetsFlutterBinding.ensureInitialized();

  late MockJsonStorageService mockStorageService;
  late InventoryRepository<PantryItem> pantryRepo;
  late InventoryRepository<MedicalItem> medicalRepo;
  late InventoryRepository<EquipmentItem> equipmentRepo;

  setUp(() {
    mockStorageService = MockJsonStorageService();
    pantryRepo = InventoryRepository<PantryItem>(mockStorageService);
    medicalRepo = InventoryRepository<MedicalItem>(mockStorageService);
    equipmentRepo = InventoryRepository<EquipmentItem>(mockStorageService);
  });

  group('[InventoryRepository] addItem', () {
    test('adds a PantryItem with valid data', () async {
      when(mockStorageService.addItem(any)).thenAnswer((_) async => {});

      await pantryRepo.addItem(
        itemType: ItemType.pantryItem,
        name: 'Rice',
        amount: 2,
        weightKg: 1.5,
        calories100g: 100,
        expirationDate: DateTime(2025, 12, 31),
        categories: {FoodCategory.carbohydrate: 30.0},
      );

      verify(mockStorageService.addItem(any)).called(1);
    });

    test('adds an EquipmentItem with valid data', () async {
      when(mockStorageService.addItem(any)).thenAnswer((_) async => {});

      await equipmentRepo.addItem(
        itemType: ItemType.equipmentItem,
        name: 'Flashlight',
        expirationDate: DateTime(2026, 01, 01),
      );

      verify(mockStorageService.addItem(any)).called(1);
    });

    test('[InventoryRepository] addItem throws ArgumentError when name is too long', () async {
      final repository = InventoryRepository<PantryItem>(mockStorageService);
      final longName = 'A' * (MAXIMUM_ALLOWED_NAME_LENGTH + 1);

      expect(
            () async => await repository.addItem(
          itemType: ItemType.pantryItem,
          name: longName,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('addItem allows name of exactly MAXIMUM_ALLOWED_NAME_LENGTH', () async {
      when(mockStorageService.addItem(any)).thenAnswer((_) async => {});

      final validName = 'B' * MAXIMUM_ALLOWED_NAME_LENGTH;

      await pantryRepo.addItem(
        itemType: ItemType.pantryItem,
        name: validName,
      );

      verify(mockStorageService.addItem(any)).called(1);
    });

    test('adds a MedicalItem without calories', () async {
      when(mockStorageService.addItem(any)).thenAnswer((_) async => {});

      await medicalRepo.addItem(
        itemType: ItemType.medicalItem,
        name: 'Bandage',
      );

      verify(mockStorageService.addItem(any)).called(1);
    });

    test('throws ArgumentError if weight is negative', () async {
      expect(
            () async => await pantryRepo.addItem(
          itemType: ItemType.pantryItem,
          name: 'Rice',
          weightKg: -2.0,
        ),
        throwsArgumentError,
      );
    });
  });

  group('[InventoryRepository] updateItem', () {
    test('updates a PantryItem with new values', () async {
      when(mockStorageService.updateItem(any, any)).thenAnswer((_) async => {});

      await pantryRepo.updateItem(
        id: 'test-id',
        itemType: ItemType.pantryItem,
        name: 'Updated Rice',
        calories100g: 150.0,
      );

      verify(mockStorageService.updateItem(any, any)).called(1);
    });

    test('updates a MedicalItem with new values', () async {
      when(mockStorageService.updateItem(any, any)).thenAnswer((_) async => {});

      await medicalRepo.updateItem(
        id: 'med-id',
        itemType: ItemType.medicalItem,
        name: 'Updated Bandage',
      );

      verify(mockStorageService.updateItem(any, any)).called(1);
    });

    test('updates an EquipmentItem with new values', () async {
      when(mockStorageService.updateItem(any, any)).thenAnswer((_) async => {});

      await equipmentRepo.updateItem(
        id: 'equip-id',
        itemType: ItemType.equipmentItem,
        name: 'Updated Flashlight',
      );

      verify(mockStorageService.updateItem(any, any)).called(1);
    });
  });

  group('[InventoryRepository] deleteItem', () {
    test('deletes item from storage and internal list', () async {
      when(mockStorageService.deleteItem(any))
          .thenAnswer((_) async => 'Item deleted');

      final fakeItem = PantryItem(
        id: 'fake-id',
        name: 'Canned Beans',
        amount: 1,
        expirationDate: null,
        calories100g: null,
        weightKg: null,
        categories: {},
        excludeFromDateTracker: true,
        excludeFromCaloriesTracker: true,
      );

      pantryRepo.items.add(fakeItem);

      await pantryRepo.deleteItem('fake-id');

      expect(pantryRepo.items.any((i) => i.id == 'fake-id'), false);
      verify(mockStorageService.deleteItem('fake-id')).called(1);
    });
  });

  test('getAllItems returns items from storage', () async {
    final pantryItem = PantryItem(
      id: 'id-1',
      name: 'Oats',
      amount: 1,
      expirationDate: null,
      calories100g: null,
      weightKg: null,
      categories: {},
      excludeFromDateTracker: true,
      excludeFromCaloriesTracker: true,
    );

    when(mockStorageService.getAllItems()).thenAnswer((_) async => [pantryItem]);

    final items = await pantryRepo.getAllItems();

    expect(items, isA<List<PantryItem>>());
    expect(items.length, 1);
    expect(items[0].name, 'Oats');
  });

  test('getItem returns item from internal list by index', () async {
    final item = PantryItem(
      id: 'id-2',
      name: 'Beans',
      amount: 1,
      expirationDate: null,
      calories100g: null,
      weightKg: null,
      categories: {},
      excludeFromDateTracker: true,
      excludeFromCaloriesTracker: true,
    );

    pantryRepo.items.add(item);
    final result = await pantryRepo.getItem(0);

    expect(result.id, 'id-2');
    expect(result.name, 'Beans');
  });
}
