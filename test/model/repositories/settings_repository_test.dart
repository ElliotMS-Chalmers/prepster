import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prepster/model/services/settings_service.dart';
import 'package:prepster/model/repositories/settings_repository.dart';
import 'package:prepster/utils/default_settings.dart';

void main() {
  group('SettingsRepository Tests', () {
    late SettingsService settingsService;
    late SettingsRepository settingsRepo;
    late SharedPreferences sharedPreferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
      settingsService = SettingsService.instance;
      settingsRepo = SettingsRepository(settingsService);
    });

    tearDown(() async {
      // Clear SharedPreferences after each test
      await sharedPreferences.clear();
    });

    test('Initial language is null', () async {
      final language = await settingsRepo.getSelectedLanguage();
      expect(language, null);
    });

    test('Set and get language', () async {
      const newLanguage = 'sv';
      settingsRepo.setLanguage(newLanguage);
      final language = await settingsRepo.getSelectedLanguage();
      expect(language, newLanguage);
    });

    test('Initial notifications are default', () async {
      final notifications = await settingsRepo.getNotifications();
      expect(notifications, DEFAULT_NOTIFICATIONS);
    });

    test('Set and get notifications', () async {
      const newNotifications = true;
      await settingsRepo.setNotifications(newNotifications);
      final notifications = await settingsRepo.getNotifications();
      expect(notifications, newNotifications);
    });

    test('Initial notify days before is default', () async {
      final notifyDaysBefore = await settingsRepo.getNotifyDaysBefore();
      expect(notifyDaysBefore, DEFAULT_NOTIFY_DAYS_BEFORE);
    });

    test('Set and get notify days before', () async {
      const newNotifyDaysBefore = 7;
      await settingsRepo.setNotifyDaysBefore(newNotifyDaysBefore);
      final notifyDaysBefore = await settingsRepo.getNotifyDaysBefore();
      expect(notifyDaysBefore, newNotifyDaysBefore.toString());
    });

    test('Initial household is empty', () async {
      final household = await settingsRepo.getHousehold();
      expect([], household);
    });

    test('Add a household member', () async {
      String name = 'John';
      int birthYear = 1994;
      String sex = 'M';

      String id = await settingsRepo.addHouseholdMember(name: name, birthYear: birthYear, sex: sex);

      final household = await settingsRepo.getHousehold();

      expect(
        household,
        equals([
          {'id': id, 'name': name, 'birthYear': birthYear, 'sex': sex},
        ]),
      );
    });

    test('Delete a household member by uuid', () async {
      String id1 = await settingsRepo.addHouseholdMember(name: 'John', birthYear: 1994, sex: 'M');
      String id2 = await settingsRepo.addHouseholdMember(name: 'Jane', birthYear:  1990, sex:  'F');

      await settingsRepo.deleteHouseholdMember(id1);

      final household = await settingsRepo.getHousehold();

      expect(false, equals(household.any((member) => member['id'] == id1)));
    });
  });
}
