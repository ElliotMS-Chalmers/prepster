import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepster/model/services/expiration_check_service.dart';

void main() {
  late ExpirationCheckService service;
  late Directory tempDir;
  late File testFile;
  final String testFileName = 'test_pantry_item.json';

  final DateTime testDate = DateTime(2025, 5, 8,); //reference date

  final String expiringSoonDate =
      DateTime(2025, 5, 13).toString().split(' ')[0];
  final String farFutureDate =
      DateTime(2026, 5, 13).toString().split(' ')[0];
  final String expiredDate =
      DateTime(2025, 5, 3).toString().split(' ')[0];

  setUp(() async {
    // Create a temporary directory for the test
    tempDir = await Directory.systemTemp.createTemp('pantry_test_');

    // Create test JSON file with sample data
    testFile = File('${tempDir.path}/$testFileName');

    // Mock the pantry items data with date-only expiration dates
    final Map<String, dynamic> testData = {
      "item1": {
        "id": "item1",
        "name": "Expiring Soon Item",
        "amount": 1,
        "expirationDate": expiringSoonDate,
        "calories100g": 100.0,
        "weightKg": 1.0,
        "categories": {"carbohydrate": 40.0, "protein": 10.0, "fat": 20.0},
        "excludeFromDateTracker": false,
        "excludeFromCaloriesTracker": false,
      },
      "item2": {
        "id": "item2",
        "name": "Far Future Item",
        "amount": 1,
        "expirationDate": farFutureDate,
        "calories100g": 200.0,
        "weightKg": 2.0,
        "categories": {"carbohydrate": 30.0, "protein": 20.0, "fat": 10.0},
        "excludeFromDateTracker": false,
        "excludeFromCaloriesTracker": false,
      },
      "item3": {
        "id": "item3",
        "name": "Expired Item",
        "amount": 1,
        "expirationDate": expiredDate,
        "calories100g": 150.0,
        "weightKg": 0.5,
        "categories": {"carbohydrate": 20.0, "protein": 30.0, "fat": 15.0},
        "excludeFromDateTracker": false,
        "excludeFromCaloriesTracker": false,
      },
    };

    await testFile.writeAsString(json.encode(testData));

    // Create a service with a fixed test date
    service = ExpirationCheckService(
      testFileName,
      basePath: '${tempDir.path}/',
      testDate: testDate,
    );
  });

  tearDown(() async {
    // Clean up the temp directory
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('getItemsNearingExpiration returns correct items', () async {
    // Set notification period to 10 days
    final int notifyDaysBefore = 10;

    // Call the service method
    final items = await service.getItemsNearingExpiration(notifyDaysBefore);

    // Verify the correct items are returned
    expect(items.length, 1); // Only 'Expiring Soon Item' should be returned

    final item = items.first;
    expect(item['id'], 'item1');
    expect(item['name'], 'Expiring Soon Item');
    expect(item['expirationDate'], expiringSoonDate);

    // Check that the far future item is not included
    expect(items.where((item) => item['id'] == 'item2').isEmpty, true);

    // Check that the already expired item is not included
    expect(items.where((item) => item['id'] == 'item3').isEmpty, true);
  });

  test(
    'getItemsNearingExpiration returns items correctly when notifyDaysBefore is large',
    () async {
      // Set a large notification period to include far future items
      final int notifyDaysBefore = 365; // 1 year

      // Call the service method
      final items = await service.getItemsNearingExpiration(notifyDaysBefore);

      // Verify correct items are returned
      expect(
        items.length,
        2,
      ); // Both 'Expiring Soon Item' and 'Far Future Item' should be included

      // Check that items are sorted by expiration date (soonest first)
      expect(items[0]['id'], 'item1');
      expect(items[0]['expirationDate'], expiringSoonDate);
      expect(items[1]['id'], 'item2');
      expect(items[1]['expirationDate'], farFutureDate);

      // Check that the expired item is not included
      expect(items.where((item) => item['id'] == 'item3').isEmpty, true);
    },
  );

  test(
    'getItemsNearingExpiration handles empty or non-existent file',
    () async {
      await testFile.delete();

      final items = await service.getItemsNearingExpiration(10);

      expect(items.isEmpty, true);
    },
  );
}
