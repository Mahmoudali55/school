import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cache/hive/hive_methods.dart';
import '../theme_enum.dart';

part 'app_theme_state.dart';

class AppThemeCubit extends Cubit<AppThemeState> {
  AppThemeCubit() : super(AppThemeInitial());

  ThemeEnum _theme = ThemeEnum.light;

  /// تهيئة السمة من التخزين المحلي
  Future<void> initial() async {
    try {
      emit(AppThemeLoading());

      final savedTheme = await HiveMethods.getTheme();
      _theme = savedTheme;

      emit(AppThemeUpdated(theme: _theme));
    } catch (error) {
      // في حالة الخطأ، نستخدم الوضع الفاتح كإفتراضي
      _theme = ThemeEnum.light;
      emit(AppThemeUpdated(theme: _theme));
      // يمكن إضافة تسجيل الخطأ هنا
      print('Error loading theme: $error');
    }
  }

  /// تبديل الوضع بين فاتح وغامق
  void toggleTheme() {
    try {
      _theme = _theme == ThemeEnum.light ? ThemeEnum.dark : ThemeEnum.light;
      HiveMethods.updateThem(_theme);
      emit(AppThemeUpdated(theme: _theme));
    } catch (error) {
      // في حالة الخطأ، نرسل حالة الخطأ
      emit(AppThemeError(error: error.toString()));
      // نعود للقيمة السابقة
      _theme = _theme == ThemeEnum.light ? ThemeEnum.dark : ThemeEnum.light;
    }
  }

  /// تعيين سمة محددة
  void setTheme(ThemeEnum newTheme) {
    try {
      if (_theme != newTheme) {
        _theme = newTheme;
        HiveMethods.updateThem(_theme);
        emit(AppThemeUpdated(theme: _theme));
      }
    } catch (error) {
      emit(AppThemeError(error: error.toString()));
    }
  }

  /// تعيين الوضع الفاتح
  void setLightTheme() {
    setTheme(ThemeEnum.light);
  }

  /// تعيين الوضع الغامق
  void setDarkTheme() {
    setTheme(ThemeEnum.dark);
  }

  /// هل الوضع الحالي غامق؟
  bool get isDarkMode => _theme == ThemeEnum.dark;

  /// هل الوضع الحالي فاتح؟
  bool get isLightMode => _theme == ThemeEnum.light;

  /// الحصول على السمة الحالية
  ThemeEnum get theme => _theme;

  /// Setter للسمة مع التحقق
  set theme(ThemeEnum value) {
    if (_theme != value) {
      _theme = value;
      try {
        HiveMethods.updateThem(_theme);
        emit(AppThemeUpdated(theme: _theme));
      } catch (error) {
        emit(AppThemeError(error: error.toString()));
      }
    }
  }

  /// إعادة تعيين السمة للإفتراضية
  void resetToDefault() {
    setTheme(ThemeEnum.light);
  }

  /// دالة مساعدة للحصول على اسم الوضع الحالي
  String get currentThemeName {
    switch (_theme) {
      case ThemeEnum.light:
        return 'فاتح';
      case ThemeEnum.dark:
        return 'غامق';
    }
  }
}
