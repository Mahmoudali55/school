import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/services/services_locator.dart';
import 'core/theme/theme_enum.dart';


class ServiceInitialize {
  ServiceInitialize._();
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Hive.initFlutter();
    Hive.registerAdapter(ThemeEnumAdapter());
    try {
     
    } catch (e) {
      debugPrint(
        'Warning: Hive adapters failed to register (might be already registered or not generated): $e',
      );
    }
    // Initialize Secure Storage for hardware-backed keys
    const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
    
    List<int> encryptionKey;
    try {
      String? secureHiveKey = await secureStorage.read(key: 'secure_hive_key');
      if (secureHiveKey == null) {
        final key = Hive.generateSecureKey();
        await secureStorage.write(key: 'secure_hive_key', value: base64Url.encode(key));
        encryptionKey = key;
      } else {
        encryptionKey = base64Url.decode(secureHiveKey);
      }
    } catch (e) {
      debugPrint("Warning: Failed to read/write secure key, generating a secure backup: $e");
      final key = Hive.generateSecureKey();
      encryptionKey = key;
    }

    await Hive.openBox('app', encryptionCipher: HiveAesCipher(encryptionKey));
    await ScreenUtil.ensureScreenSize();
    await EasyLocalization.ensureInitialized();
    await initDependencies();
  }
}
