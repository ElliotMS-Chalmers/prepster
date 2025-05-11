import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:prepster/utils/default_settings.dart';
import 'package:timezone/standalone.dart';

import 'expiration_check_service.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:prepster/utils/logger.dart';

import 'dart:math';

class NotificationService {
  final int _notifyDaysBefore;
  final String _timezone = TIMEZONE;
  final Set<String> _storageFiles;
  Set<Map<String, dynamic>> allItems = {};
  Map<String, dynamic> notifications = {};
  late final Location location;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService(
    this._storageFiles,
    this._notifyDaysBefore,
    bool notificationsEnabled,
  ) {
    if (notificationsEnabled) {
      _initializeNotifications();
      _requestExactAlarmPermission().then((granted) async {
        if (granted) {
          logger.i('Exact alarm permission granted');
          await rescheduleNotifications();
        } else {
          logger.i('Exact alarm permission denied.');
        }
      });
    } else {
      logger.i(
        'Notifications are disabled. NotificationService will not be initialized.',
      );
    }
  }

  Future<void> rescheduleNotifications() async {
    _logInitializationDetails();
    _initializeNotifications();

    tz.initializeTimeZones();
    location = tz.getLocation(_timezone);

    await _initData();
    //_printPendingNotifications();

    await clearAllScheduledNotifications();

    _scheduleNotifications();
    _printPendingNotifications();
  }

  Future<bool> _requestExactAlarmPermission() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    if (androidImplementation != null) {
      final bool? granted =
          await androidImplementation.requestExactAlarmsPermission();
      return granted ?? false;
    }
    // On non-Android platforms, exact alarms might not be a concern
    // or handled differently. Return true to proceed with initialization.
    return true;
  }

  void _initializeNotifications() {
    print('Initializing notifications...');
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _logInitializationDetails() {
    logger.i('NotificationService initialized with:');
    logger.i('Notify days before: $_notifyDaysBefore');
    logger.i('Timezone: $_timezone');
    logger.i('Storage files: $_storageFiles');
  }

  Future<void> _initData() async {
    for (String file in _storageFiles) {
      var service = ExpirationCheckService(file);
      var items = await service.getItemsNearingExpiration(_notifyDaysBefore);
      allItems.addAll(items);
    }
    logger.i('All items nearing expiration: $allItems');

    for (Map item in allItems) {
      // Extract the expiration date and item details
      String expirationDate = item['expirationDate'];
      String id = item['id'];
      String name = item['name'];

      // Check if the date already exists in the notifications map
      if (!notifications.containsKey(expirationDate)) {
        notifications[expirationDate] = [];
      }

      // Add the tuple (id, name) to the list for the corresponding date
      notifications[expirationDate].add({'id': id, 'name': name});
    }

    logger.i('Notifications map: $notifications');
  }

  Future<void> _printPendingNotifications() async {
    try {
      final List<PendingNotificationRequest> pending =
          await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
      print('Pending notifications:');
      if (pending.isEmpty) {
        print('No pending notifications scheduled.');
      } else {
        for (final request in pending) {
          print('  ID: ${request.id}');
          print('  Title: ${request.title}');
          print('  Body: ${request.body}');
          print('  Payload: ${request.payload}');
        }
      }
    } catch (e) {
      logger.e('Error getting pending notifications: $e');
    }
  }

  Future<void> clearAllScheduledNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      logger.i('All scheduled notifications cleared.');
    } catch (e) {
      logger.e('Error clearing scheduled notifications: $e');
    }
  }

  Future<void> _scheduleNotifications() async {
    final now = tz.TZDateTime.now(location);

    for (String date in notifications.keys) {
      // Extract the list of ids from the notifications map
      List<String> ids =
          notifications[date]
              .map<String>((item) => item['id'] as String)
              .toList();

      // Parse the date string into a DateTime object
      final parsedDate = DateTime.parse(date);

      // Check if the parsed date is in the past
      if (parsedDate.isBefore(now)) {
        logger.i(
          'Error: Cannot schedule a notification in the past. Scheduled date: $parsedDate',
        );
        continue; // Skip scheduling this notification
      }

      // Pass the list of ids to _scheduleOneNotification
      print('Scheduling notification for date: $parsedDate with IDs: $ids');
      await _scheduleOneNotification(date, ids);
    }
  }

  Future<void> _scheduleOneNotification(String date, List payload) async {
    print("Scheduling one notification...");
    var notificationId = int.parse(date.replaceAll('-', ''));

    //var scheduledTime = _getTimeNow(); // for debugging only
    var scheduledTime = _getTime(date);

    var nrOfItems = payload.length;
    var expDuration = DateTime.parse(date).difference(DateTime.now());
    var expDays = expDuration.inDays;
    String body;

    if (nrOfItems > 1) {
      body = 'You have ${nrOfItems} items expiring in ${expDays} days!';
    } else {
      body = 'You have ${nrOfItems} item expiring in ${expDays} days!';
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'expiration_channel',
          'Expiration notifications',
          channelDescription: 'Expiration notifications',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId, // id
        'Prepster: Expiration date warning!', // title
        body, // body
        scheduledTime, // scheduledDate
        platformChannelSpecifics, // notificationDetails
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: jsonEncode(payload), // payload
      );
      print('A notification has been scheduled for $scheduledTime');
    } catch (e) {
      print('Error scheduling a notification: $e');
    }
  }

  /*
  // For debugging purposes, makes notification appear in 1 minute after
  // the app starts. Used for manual testing and debugging!
  TZDateTime _getTimeNow() {
    final now = tz.TZDateTime.now(location);
    final scheduledTime = now.add(const Duration(minutes: 1));
    return scheduledTime;
  }
   */

  TZDateTime _getTime(String date) {
    // This function creates a TZDateTime object for the given date,
    // with a random time between 12:00 and 19:00.
    // An offset based of the notifyDaysBefore variable is
    // subtracted from the expiration date to show the notification
    // before the actual expiration date.

    var expirationDate = DateTime.parse(date);
    var rng = Random();
    var randomHour = rng.nextInt(7) + 12;
    var randomMinute = rng.nextInt(7) + 12;

    var notificationDate = tz.TZDateTime(
      location,
      expirationDate.year,
      expirationDate.month,
      expirationDate.day,
      randomHour,
      randomMinute,
    );

    var adjustedTime = notificationDate.subtract(
      Duration(days: _notifyDaysBefore),
    );

    return adjustedTime;
  }

  /*

  Future<Set<String>> _getPendingNotifications() async {
    // Returns a set of IDs from the payload of pending notifications
    // so that we know what items are already scheduled for notifications
    // and we can avoid scheduling them again.

    final Set<String> listOfIds = <String>{};
    try {
      final List<PendingNotificationRequest> pending =
          await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
      if (pending.isEmpty) {
        print('No pending notifications scheduled.');
        return listOfIds;
      } else {
        for (final request in pending) {
          final String? payload = request.payload;
          if (payload != null) {
            try {
              // Try decoding as a List<String>
              final List<dynamic> payloadList = jsonDecode(payload);
              for (final element in payloadList) {
                if (element is String) {
                  listOfIds.add(element);
                } else {
                  print(
                    'Warning: Non-string element found in payload: $element',
                  );
                }
              }
            } catch (e) {
              // If not a valid JSON list, treat the entire payload as a single ID
              listOfIds.add(payload);
            }
          }
        }
        return listOfIds;
      }
    } catch (e) {
      print('Error getting pending notifications: $e');
      return listOfIds;
    }
  }

   */
}
