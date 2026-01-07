import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/services/services_locator.dart';
import 'core/theme/theme_enum.dart';
import 'features/attendance/data/models/student_face_model.dart';
import 'features/attendance/data/models/attendance_record_model.dart';

class ServiceInitialize {
  ServiceInitialize._();
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Hive.initFlutter();
    Hive.registerAdapter(ThemeEnumAdapter());
    try {
      Hive.registerAdapter(StudentFaceModelAdapter());
      Hive.registerAdapter(AttendanceRecordModelAdapter());
      Hive.registerAdapter(AttendanceStatusAdapter());
      Hive.registerAdapter(RecognitionMethodAdapter());
    } catch (e) {
      debugPrint(
        'Warning: Hive adapters failed to register (might be already registered or not generated): $e',
      );
    }
    await Hive.openBox('app');
    await ScreenUtil.ensureScreenSize();
    await EasyLocalization.ensureInitialized();
    await initDependencies();
  }
}
