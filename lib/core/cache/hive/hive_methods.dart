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

  static void updateUserName(String userName) {
    _box.put('userName', userName);
  }

  static String getUserName2() {
    return _box.get('userName', defaultValue: '');
  }

  static String? getToken() {
    return _box.get('token');
  }

  static void updateToken(String token) {
    _box.put('token', token);
  }

  static void updateUserid(String id) {
    _box.put('id', id);
  }

  static String getUserid() {
    return _box.get('id', defaultValue: '');
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

  static void updateUserStage(String stageCode) {
    _box.put('stageCode', stageCode);
  }

  static void updateUserSection(String sectionCode) {
    _box.put('sectionCode', sectionCode);
  }

  static void updateUserClassCode(String classCode) {
    _box.put('classCode', classCode);
  }

  static getUserClassCode() {
    return _box.get('classCode', defaultValue: '');
  }

  static getUserLevelCode() {
    return _box.get('levelCode', defaultValue: '');
  }

  static getUserStage() {
    return _box.get('stageCode', defaultValue: '');
  }

  static getUserSection() {
    return _box.get('sectionCode', defaultValue: '');
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

  /// Clear all user data (token, type, name, code, etc.) while preserving app settings
  static void clearUserData() {
    _box.delete('token');
    _box.delete('type');
    _box.delete('name');
    _box.delete('code');
    _box.delete('compneyname');
    _box.delete('levelCode');
    _box.delete('stageCode');
    _box.delete('sectionCode');
    _box.delete('classCode');
  }

  /// Payment Receipts History
  static void savePaymentReceipt(Map<String, dynamic> receiptData) {
    List<dynamic> currentReceipts = _box.get('payment_receipts', defaultValue: []);
    // Insert new receipt at the beginning
    currentReceipts.insert(0, receiptData);
    _box.put('payment_receipts', currentReceipts);
  }

  static List<Map<String, dynamic>> getPaymentReceipts() {
    List<dynamic> receipts = _box.get('payment_receipts', defaultValue: []);
    return receipts.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// Saved Credit Cards
  static void saveCreditCard(Map<String, dynamic> cardData) {
    List<dynamic> currentCards = _box.get('saved_cards', defaultValue: []);
    
    // Check if card already exists (by number) to avoid duplicates
    int existingIndex = currentCards.indexWhere((c) => c['number'] == cardData['number']);
    if (existingIndex != -1) {
      currentCards[existingIndex] = cardData; // Update existing
    } else {
      currentCards.add(cardData); // Add new
    }
    
    _box.put('saved_cards', currentCards);
  }

  static List<Map<String, dynamic>> getSavedCreditCards() {
    List<dynamic> cards = _box.get('saved_cards', defaultValue: []);
    return cards.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static void deleteSavedCreditCard(int index) {
    List<dynamic> cards = _box.get('saved_cards', defaultValue: []);
    if (index >= 0 && index < cards.length) {
      cards.removeAt(index);
      _box.put('saved_cards', cards);
    }
  }
}
