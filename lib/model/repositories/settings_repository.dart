import 'package:prepster/model/services/settings_service.dart';
import 'package:prepster/utils/default_settings.dart';
import 'package:uuid/uuid.dart';

class SettingsRepository {
  final SettingsService _settingsService;

  SettingsRepository(this._settingsService);

  // Settings keys
  static const String languageKey = 'language';
  static const String notificationKey = 'notification';
  static const String notifyDaysBeforeKey = 'notifyDaysBefore';
  static const String householdKey = 'household';

  // Getters
  Future<String> getLanguage() async {
    return (await _settingsService.getValue<String>(languageKey)) ??
        DEFAULT_LANGUAGE;
  }

  Future<bool> getNotifications() async {
    return (await _settingsService.getValue<bool>(notificationKey)) ??
        DEFAULT_NOTIFICATIONS;
  }

  Future<String> getNotifyDaysBefore() async {
    final intValue = await _settingsService.getValue<int>(notifyDaysBeforeKey);
    return intValue?.toString() ?? DEFAULT_NOTIFY_DAYS_BEFORE;
  }

  Future<List<Map<String, Object>>> getHousehold() async {
    return (await _settingsService.getHousehold()) ?? [];
  }

  // Setters
  Future<void> setLanguage(String value) async {
    await _settingsService.setValue(languageKey, value);
  }

  Future<void> setNotifications(bool value) async {
    await _settingsService.setValue(notificationKey, value);
  }

  Future<void> setNotifyDaysBefore(int value) async {
    await _settingsService.setValue(notifyDaysBeforeKey, value);
  }

  Future<String> addHouseholdMember(
      String name,
      int birthYear,
      String sex,
      ) async {
    final household = await getHousehold();
    final uuid = Uuid();
    final newMember = {
      'id': uuid.v4(),
      'name': name,
      'birthYear': birthYear,
      'sex': sex,
    };
    household.add(newMember);
    await _settingsService.setValue(householdKey, household);
    return newMember['id'] as String;
  }

  Future<void> deleteHouseholdMember(String uuid) async {
    final household = await getHousehold();
    household.removeWhere((member) => member['id'] == uuid);
    await _settingsService.setValue(householdKey, household);
  }
}
