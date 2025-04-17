import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:prepster/model/services/settings_service.dart';
import 'package:prepster/utils/default_settings.dart';
import 'package:prepster/utils/logger.dart';



class SettingsRepository {
  final SettingsService _settingsService;

  SettingsRepository(this._settingsService);

  // Settings keys
  static const String _languageKey = 'language';
  static const String _notificationKey = 'notification';
  static const String _notifyDaysBeforeKey = 'notifyDaysBefore';
  static const String _householdKey = 'household';


  // Notification related

  Future<bool> getNotifications() async {
    return (await _settingsService.getValue<bool>(_notificationKey)) ??
        DEFAULT_NOTIFICATIONS;
  }

  Future<String> getNotifyDaysBefore() async {
    final intValue = await _settingsService.getValue<int>(_notifyDaysBeforeKey);
    return intValue?.toString() ?? DEFAULT_NOTIFY_DAYS_BEFORE;
  }


  Future<void> setNotifications(bool value) async {
    await _settingsService.setValue(_notificationKey, value);
  }

  Future<void> setNotifyDaysBefore(int value) async {
    await _settingsService.setValue(_notifyDaysBeforeKey, value);
  }


  // Household related

  Future<List<Map<String, Object>>> getHousehold() async {
    return (await _settingsService.getHousehold()) ?? [];
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


  // Translation related

  Future<bool> setLanguage(String languageCode) async {
    if (getAvailableLanguages().contains(languageCode)) {
      await _settingsService.setValue(_languageKey, languageCode);
      return true;
    } else {
      logger.e("Language $languageCode is not supported");
      return false;
    }
  }

  String getTranslationsPath() {
    return TRANSLATIONS_PATH;
  }

  Future<String?> getSelectedLanguage() async {
    return await _settingsService.getValue<String>(_languageKey);
  }

  List<String> getAvailableLanguages(){
    return SUPPORTED_LANGUAGES;
  }

  String getFallbackLanguage(){
    return DEFAULT_LANGUAGE;
  }

  List<Locale> getLocales() {
    return getAvailableLanguages().map((langCode) => Locale(langCode)).toList();
  }

  Locale getFallbackLocale() {
    return Locale(getFallbackLanguage());
  }

  Future<Locale> getPreferredLocale() async {
    // Check if a language is set in settingsRepo
    String? savedLanguageCode = await getSelectedLanguage();
    if (savedLanguageCode != null) {
      logger.d("Saved language: $savedLanguageCode");
      return Locale(savedLanguageCode);
    }

    // If not set in app, read from device (phone) settings
    Locale deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    String deviceLanguageCode = deviceLocale.languageCode;

    // Check if the device language is suported
    if (getAvailableLanguages().contains(deviceLanguageCode)) {
      logger.d("Device language: $deviceLanguageCode");
      return Locale(deviceLanguageCode);
    }

    // If the phone language is not supported (or could not be read), use fallback
    logger.d("Using fallback language: ${getFallbackLanguage()}");
    return Locale(getFallbackLanguage());
  }

}
