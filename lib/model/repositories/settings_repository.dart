import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:prepster/model/services/settings_service.dart';
import 'package:prepster/utils/default_settings.dart';
import 'package:prepster/utils/logger.dart';



class SettingsRepository {
  final SettingsService _settingsService;

  bool _isCacheInitialized = false;

  SettingsRepository(this._settingsService);

  // Settings keys
  static const String _languageKey = 'language';
  static const String _notificationKey = 'notification';
  static const String _notifyDaysBeforeKey = 'notifyDaysBefore';
  static const String _householdKey = 'household';

  // Cache
  String? _language;
  bool? _notificationsEnabled;
  int? _notifyDaysBefore;
  List<Map<String, Object>>? _householdMembers;

  // Dirty flag and save timer
  bool _isDirty = false;
  Timer? _saveTimer;
  static const Duration _saveDelay = Duration(milliseconds: 500);

  // Initialization
  Future<void> initializeCache() async {
    if (!_isCacheInitialized) {
      _language = await _settingsService.getValue<String>(_languageKey);
      _notificationsEnabled = await _settingsService.getValue<bool>(
        _notificationKey,
      );
      _notifyDaysBefore = await _settingsService.getValue<int>(
        _notifyDaysBeforeKey,
      );
      _householdMembers = await _settingsService.getHousehold();
      _isCacheInitialized = true;
    }
  }

  // Notification related

  Future<bool> getNotifications() async {
    return _notificationsEnabled ??
        (await _fetchAndCache(_notificationKey, DEFAULT_NOTIFICATIONS)) ??
        DEFAULT_NOTIFICATIONS;
  }

  Future<String> getNotifyDaysBefore() async {
    final cachedValue = _notifyDaysBefore;
    if (cachedValue != null) {
      return cachedValue.toString();
    }
    final fetchedValue = await _fetchAndCache<int>(
      _notifyDaysBeforeKey,
      int.parse(DEFAULT_NOTIFY_DAYS_BEFORE),
    );
    return fetchedValue?.toString() ??
        DEFAULT_NOTIFY_DAYS_BEFORE; // Added null-aware fallback
  }


  Future<void> setNotifications(bool value) async {
    if (_notificationsEnabled != value) {
      _notificationsEnabled = value;
      _markDirtyAndScheduleSave();
    }
  }

  Future<void> setNotifyDaysBefore(int value) async {
    if (_notifyDaysBefore != value) {
      _notifyDaysBefore = value;
      _markDirtyAndScheduleSave();
    }
  }

  // Household related

  Future<List<Map<String, Object>>> getHousehold() async {
    return _householdMembers ??
        (await _fetchAndCache(_householdKey, <Map<String, Object>>[])) ??
        <Map<String, Object>>[];
  }


  Future<String> addHouseholdMember({
    required String name,
    required int birthYear,
    required String sex,
  }) async {

    final household = await getHousehold();
    final uuid = const Uuid();
    final newMember = {
      'id': uuid.v4(),
      'name': name,
      'birthYear': birthYear,
      'sex': sex,
    };
    household.add(newMember);
    _householdMembers = household;
    _markDirtyAndScheduleSave();
    return newMember['id'] as String;
  }

  Future<void> deleteHouseholdMember(String uuid) async {
    final household = await getHousehold();
    final initialLength = household.length;
    household.removeWhere((member) => member['id'] == uuid);
    if (household.length != initialLength) {
      _householdMembers = household;
      _markDirtyAndScheduleSave();
    }
  }


  // Translation related

  Future<bool> setLanguage(String languageCode) async {
    if (getAvailableLanguages().contains(languageCode) &&
        _language != languageCode) {
      _language = languageCode;
      _markDirtyAndScheduleSave();
      return true;
    } else if (!getAvailableLanguages().contains(languageCode)) {
      logger.e("Language $languageCode is not supported");
    }
    return false;
  }

  String getTranslationsPath() {
    return TRANSLATIONS_PATH;
  }

  Future<String?> getSelectedLanguage() async {
    return _language ?? (await _fetchAndCache(_languageKey, null));
  }

  List<String> getAvailableLanguages() {
    return SUPPORTED_LANGUAGES;
  }

  String getFallbackLanguage() {
    return DEFAULT_LANGUAGE;
  }

  List<Locale> getLocales() {
    return getAvailableLanguages().map((langCode) => Locale(langCode)).toList();
  }

  Locale getFallbackLocale() {
    return Locale(getFallbackLanguage());
  }

  Future<Locale> getPreferredLocale() async {
    // Check if a language is in the cache
    if (_language != null) {
      logger.d("Using cached language: $_language");
      return Locale(_language!);
    }

    // If not in cache, check settings service
    String? savedLanguageCode = await getSelectedLanguage();
    if (savedLanguageCode != null) {
      logger.d("Saved language: $savedLanguageCode");
      _language = savedLanguageCode;    // Cache the saved language
      return Locale(savedLanguageCode);
    }

    // If not set in app, read from device (phone) settings
    Locale deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    String deviceLanguageCode = deviceLocale.languageCode;

    // Check if the device language is suported
    if (getAvailableLanguages().contains(deviceLanguageCode)) {
      logger.d("Device language: $deviceLanguageCode");
      _language = deviceLanguageCode;     // Cache the device language
      return Locale(deviceLanguageCode);
    }

    // If the phone language is not supported (or could not be read), use fallback
    logger.d("Using fallback language: ${getFallbackLanguage()}");
    _language = getFallbackLanguage();    // Cache the fallback language
    return Locale(getFallbackLanguage());
  }


  // Helper methods for caching and saving

  Future<T?> _fetchAndCache<T>(String key, T? defaultValue) async {
    final value = await _settingsService.getValue<T>(key) ?? defaultValue;
    switch (key) {
      case _languageKey:
        _language = value as String?;
        break;
      case _notificationKey:
        _notificationsEnabled = value as bool?;
        break;
      case _notifyDaysBeforeKey:
        _notifyDaysBefore = value as int?;
        break;
      case _householdKey:
        _householdMembers = value as List<Map<String, Object>>?;
        break;
    }
    return value;
  }

  void _markDirtyAndScheduleSave() {
    _isDirty = true;
    if (_saveTimer?.isActive ?? false) {
      _saveTimer!.cancel();
    }
    _saveTimer = Timer(_saveDelay, _saveSettings);
  }

  Future<void> _saveSettings() async {
    if (_isDirty) {
      logger.d("Saving settings to service...");
      if (_language != null) {
        await _settingsService.setValue(_languageKey, _language);
      }
      if (_notificationsEnabled != null) {
        await _settingsService.setValue(
          _notificationKey,
          _notificationsEnabled,
        );
      }
      if (_notifyDaysBefore != null) {
        await _settingsService.setValue(
          _notifyDaysBeforeKey,
          _notifyDaysBefore,
        );
      }
      if (_householdMembers != null) {
        // Ensure the list is serializable by the SettingsService
        await _settingsService.setValue(_householdKey, _householdMembers);
      }
      _isDirty = false;
      logger.d("Settings saved.");
    } else {
      logger.d("No settings changes to save.");
    }
  }
}
