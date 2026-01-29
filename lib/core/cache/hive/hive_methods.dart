import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../theme/theme_enum.dart';

class HiveMethods {
  static final _box = Hive.box('app');

  static String getLang() {
    return _box.get('lang', defaultValue: 'ar');
  }

  static void updateLang(Locale locale) {
    _box.put('lang', locale.languageCode);
  }

  static String? getToken() {
    return _box.get('token');
  }

  static void updateToken(String token) {
    _box.put('token', token);
  }

  static void deleteToken() {
    _box.delete('token');
  }

  static bool isFirstTime() {
    return _box.get('isFirstTime', defaultValue: true);
  }

  static void updateFirstTime() {
    _box.put('isFirstTime', false);
  }

  static ThemeEnum getTheme() {
    return _box.get('theme', defaultValue: ThemeEnum.light);
  }

  static String getUserName() {
    return _box.get('name', defaultValue: '');
  }

  static void updateThem(ThemeEnum theme) {
    _box.put('theme', theme);
  }

  static bool getNotificationSetting(String key) {
    return _box.get(key, defaultValue: true);
  }

  static void updateNotificationSetting(String key, bool value) {
    _box.put(key, value);
  }

  static String getType() {
    return _box.get('type', defaultValue: '');
  }

  static void updateType(String type) {
    _box.put('type', type);
  }

  static void updateName(String name) {
    _box.put('name', name);
  }

  static void updateUserLevelCode(String levelCode) {
    _box.put('levelCode', levelCode);
  }

  static void getUserLevelCode() {
    return _box.get('levelCode', defaultValue: '');
  }

  static String getUserCompanyName() {
    return _box.get('compneyname', defaultValue: '');
  }

  static void updateUserCompanyName(String name) {
    _box.put('compneyname', name);
  }

  static String getUserCode() {
    return _box.get('code', defaultValue: '');
  }

  static void updateUserCode(String code) {
    _box.put('code', code);
  }

  /// Clear all user data (token, type, name, code) while preserving app settings
  static void clearUserData() {
    _box.delete('token');
    _box.delete('type');
    _box.delete('name');
    _box.delete('code');
  }
}
