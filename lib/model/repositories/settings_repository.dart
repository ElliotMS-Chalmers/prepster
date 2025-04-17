import 'package:prepster/model/services/settings_service.dart';
import 'package:prepster/utils/default_settings.dart';
import 'package:uuid/uuid.dart';
import 'package:prepster/utils/default_settings.dart';

class SettingsRepository {
  final SettingsService _settingsService;

  SettingsRepository(this._settingsService);

  // Settings keys
  static const String _languageKey = 'language';
  static const String _notificationKey = 'notification';
  static const String _notifyDaysBeforeKey = 'notifyDaysBefore';
  static const String _householdKey = 'household';

  // Getters
  Future<String?> getSelectedLanguage() async {
    return await _settingsService.getValue<String>(_languageKey);
  }

  List<String> getAvailableLanguages(){
    return SUPPORTED_LANGUAGES;
  }

  String getFallbackLanguage(){
    return DEFAULT_LANGUAGE;
  }

  Future<bool> getNotifications() async {
    return (await _settingsService.getValue<bool>(_notificationKey)) ??
        DEFAULT_NOTIFICATIONS;
  }

  Future<String> getNotifyDaysBefore() async {
    final intValue = await _settingsService.getValue<int>(_notifyDaysBeforeKey);
    return intValue?.toString() ?? DEFAULT_NOTIFY_DAYS_BEFORE;
  }

  Future<List<Map<String, Object>>> getHousehold() async {
    return (await _settingsService.getHousehold()) ?? [];
  }

  // Setters
  Future<void> setLanguage(String value) async {
    await _settingsService.setValue(_languageKey, value);
  }

  Future<void> setNotifications(bool value) async {
    await _settingsService.setValue(_notificationKey, value);
  }

  Future<void> setNotifyDaysBefore(int value) async {
    await _settingsService.setValue(_notifyDaysBeforeKey, value);
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
    await _settingsService.setValue(_householdKey, household);
    return newMember['id'] as String;
  }

  Future<void> deleteHouseholdMember(String uuid) async {
    final household = await getHousehold();
    household.removeWhere((member) => member['id'] == uuid);
    await _settingsService.setValue(_householdKey, household);
  }
}
