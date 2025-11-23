import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/app_theme_cubit.dart';
import 'theme_enum.dart';

class AppTheme {
  /// الحصول على القيمة المناسبة بناءً على الوضع الحالي (فاتح/غامق)
  static T getByTheme<T>(
    BuildContext context, {
    required T light,
    required T dark,
    bool listen = true,
  }) {
    final themeCubit = BlocProvider.of<AppThemeCubit>(context, listen: listen);
    
    switch (themeCubit.theme) {
      case ThemeEnum.light:
        return light;
      case ThemeEnum.dark:
        return dark;
      default:
        // كإحتياطي، نعود للوضع الفاتح
        return light;
    }
  }

  /// الحصول على سمة التطبيق الحالية
  static ThemeData getCurrentTheme(BuildContext context, {bool listen = true}) {
    return getByTheme(
      context,
      light: _lightTheme,
      dark: _darkTheme,
      listen: listen,
    );
  }

  /// تبديل الوضع بين فاتح وغامق
  static void toggleTheme(BuildContext context) {
    final themeCubit = BlocProvider.of<AppThemeCubit>(context, listen: false);
    themeCubit.toggleTheme();
  }

  /// هل الوضع الحالي غامق؟
  static bool isDarkMode(BuildContext context, {bool listen = true}) {
    final themeCubit = BlocProvider.of<AppThemeCubit>(context, listen: listen);
    return themeCubit.theme == ThemeEnum.dark;
  }

  /// هل الوضع الحالي فاتح؟
  static bool isLightMode(BuildContext context, {bool listen = true}) {
    final themeCubit = BlocProvider.of<AppThemeCubit>(context, listen: listen);
    return themeCubit.theme == ThemeEnum.light;
  }

  // =========== THEME DEFINITIONS ===========

  /// السمة الفاتحة
  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF2563EB),
    primaryColorLight: const Color(0xFFDBEAFE),
    primaryColorDark: const Color(0xFF1E3A8A),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2563EB),
      secondary: Color(0xFF10B981),
      surface: Colors.white,
      background: Color(0xFFF8FAFC),
      error: Color(0xFFEF4444),
    ),
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF0F172A),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF64748B)),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0F172A),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF0F172A),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF0F172A),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF2563EB)),
      ),
    ),
  );

  /// السمة الغامقة
  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF3B82F6),
    primaryColorLight: const Color(0xFF1E3A8A),
    primaryColorDark: const Color(0xFFDBEAFE),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF3B82F6),
      secondary: Color(0xFF34D399),
      surface: Color(0xFF1E293B),
      background: Color(0xFF0F172A),
      error: Color(0xFFF87171),
    ),
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    cardColor: const Color(0xFF1E293B),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E293B),
      foregroundColor: Color(0xFFF8FAFC),
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF94A3B8)),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: Color(0xFFF8FAFC),
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Color(0xFFF8FAFC),
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Color(0xFFF8FAFC),
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFFF8FAFC),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFFF8FAFC),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF3B82F6)),
      ),
    ),
  );

  // =========== QUICK ACCESSORS ===========

  /// الحصول على لون الخلفية الحالي
  static Color getBackgroundColor(BuildContext context, {bool listen = true}) {
    return getByTheme(
      context,
      light: const Color(0xFFF8FAFC),
      dark: const Color(0xFF0F172A),
      listen: listen,
    );
  }

  /// الحصول على لون السطح الحالي
  static Color getSurfaceColor(BuildContext context, {bool listen = true}) {
    return getByTheme(
      context,
      light: Colors.white,
      dark: const Color(0xFF1E293B),
      listen: listen,
    );
  }

  /// الحصول على لون النص الأساسي الحالي
  static Color getTextColor(BuildContext context, {bool listen = true}) {
    return getByTheme(
      context,
      light: const Color(0xFF0F172A),
      dark: const Color(0xFFF8FAFC),
      listen: listen,
    );
  }

  /// الحصول على لون النص الثانوي الحالي
  static Color getSecondaryTextColor(BuildContext context, {bool listen = true}) {
    return getByTheme(
      context,
      light: const Color(0xFF64748B),
      dark: const Color(0xFF94A3B8),
      listen: listen,
    );
  }
}