import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/services/services_locator.dart';
import 'core/theme/theme_enum.dart';

class ServiceInitialize {
  ServiceInitialize._();
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Hive.initFlutter();
    Hive.registerAdapter(ThemeEnumAdapter());
    await Hive.openBox('app');
    await ScreenUtil.ensureScreenSize();
    await EasyLocalization.ensureInitialized();
    await initDependencies();
  }
}
