import 'dart:convert';
import 'dart:io';

import '../../utils/default_settings.dart';

class ExpirationCheckService {
  final String basePath;
  final String filename;
  final DateTime? testDate; // Optional for testing

  // Filename (for json file) and optional basePath for testing
  ExpirationCheckService(
    this.filename, {
    this.basePath = '/data/data/com.example.prepster/app_flutter/',
    this.testDate, // for test predictability
  });

  // Get the full file path
  String get jsonFilePath => '$basePath$filename';

  // Returns a List of Maps containing id, name,
  // and expirationDate (as YYYY-MM-DD string)
  // for items that will expire within notifyDaysBefore days
  Future<List<Map<String, dynamic>>> getItemsNearingExpiration(
    int notifyDaysBefore,
  ) async {
    try {
      // Read the JSON file
      final file = File(jsonFilePath);
      if (!await file.exists()) {
        return [];
      }

      final jsonContent = await file.readAsString();
      final Map<String, dynamic> data = json.decode(jsonContent);

      // Use testDate if provided (for tests), otherwise use current date
      final today = testDate ?? DateTime.now();

      // Strip time from today for consistent date comparison
      final todayDate = DateTime(today.year, today.month, today.day);

      final List<Map<String, dynamic>> expiringItems = [];

      // Process each item in the JSON
      data.forEach((key, value) {
        if (value != null && value is Map<String, dynamic>) {
          final String id = value['id'] as String? ?? '';
          final String name = value['name'] as String? ?? '';
          final String expirationDateStr =
              value['expirationDate'] as String? ?? '';

          if (id.isNotEmpty &&
              name.isNotEmpty &&
              expirationDateStr.isNotEmpty) {
            // Parse expirationDate and strip time information
            final DateTime fullExpirationDate = DateTime.parse(
              expirationDateStr,
            );
            final DateTime expirationDate = DateTime(
              fullExpirationDate.year,
              fullExpirationDate.month,
              fullExpirationDate.day,
            );

            final int daysUntilExpiration =
                expirationDate.difference(todayDate).inDays;

            // Include items expiring within notifyDaysBefore days and notification window
            if (daysUntilExpiration >= 0 &&
                daysUntilExpiration <= notifyDaysBefore+NOTIFICATION_WINDOW_DAYS) {
              // Convert expirationDate to YYYY-MM-DD string
              final String expirationDateString =
                  expirationDate.toString().split(' ')[0];
              expiringItems.add({
                'id': id,
                'name': name,
                'expirationDate': expirationDateString,
              });
            }
          }
        }
      });

      // sort by expiration date (soonest first)
      expiringItems.sort(
        (a, b) => (DateTime.parse(
          a['expirationDate'] as String,
        )).compareTo(DateTime.parse(b['expirationDate'] as String)),
      );

      return expiringItems;
    } catch (e) {
      return [];
    }
  }
}
