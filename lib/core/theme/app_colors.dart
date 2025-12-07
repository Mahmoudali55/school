import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppColor {
  // =========== PRIMARY COLORS ===========
  /// PRIMARY COLOR (#2563EB) - اللون الأساسي
  static Color primaryColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF2563EB),
      dark: const Color(0xFF3B82F6),
      listen: listen,
    );
  }

  /// PRIMARY CONTAINER - للخلفيات والأسطح
  static Color primaryContainer(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFDBEAFE),
      dark: const Color(0xFF1E3A8A),
      listen: listen,
    );
  }

  // =========== SECONDARY COLORS ===========
  /// SECONDARY COLOR (#10B981) - اللون الثانوي
  static Color secondAppColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF10B981),
      dark: const Color(0xFF34D399),
      listen: listen,
    );
  }

  /// SECONDARY CONTAINER
  static Color secondaryContainer(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFD1FAE5),
      dark: const Color(0xFF065F46),
      listen: listen,
    );
  }

  // =========== ACCENT COLORS ===========
  /// ACCENT COLOR (#F59E0B) - للتأكيد والتنبيهات
  static Color accentColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFF59E0B),
      dark: const Color(0xFFFBBF24),
      listen: listen,
    );
  }

  // =========== NEUTRAL COLORS ===========
  /// BACKGROUND COLOR - خلفية التطبيق
  static Color scaffoldColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getBackgroundColor(context, listen: listen);
  }

  /// SURFACE COLOR - لون الأسطح والكروت
  static Color surfaceColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getSurfaceColor(context, listen: listen);
  }

  /// SURFACE VARIANT - للأسطح المختلفة
  static Color surfaceVariant(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFF1F5F9),
      dark: const Color(0xFF334155),
      listen: listen,
    );
  }

  // =========== TEXT COLORS ===========
  /// TEXT COLOR - النص الأساسي
  static Color textColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getTextColor(context, listen: listen);
  }

  /// TEXT SECONDARY - النص الثانوي
  static Color textSecondary(BuildContext context, {bool listen = true}) {
    return AppTheme.getSecondaryTextColor(context, listen: listen);
  }

  /// TEXT TERTIARY - النص الثالثي
  static Color textTertiary(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF94A3B8),
      dark: const Color(0xFF64748B),
      listen: listen,
    );
  }

  /// HINT COLOR - نص التلميحات
  static Color hintColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF94A3B8),
      dark: const Color(0xFF475569),
      listen: listen,
    );
  }

  // =========== BORDER & DIVIDER COLORS ===========
  /// BORDER COLOR - حدود الحقول
  static Color borderColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFE2E8F0),
      dark: const Color(0xFF334155),
      listen: listen,
    );
  }

  /// DIVIDER COLOR - خطوط الفصل
  static Color dividerColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFE2E8F0),
      dark: const Color(0xFF334155),
      listen: listen,
    );
  }

  // =========== FORM COLORS ===========
  /// FORM FILL COLOR - خلفية الحقول
  static Color textFormFillColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: Colors.white,
      dark: const Color(0xFF1E293B),
      listen: listen,
    );
  }

  /// FORM BORDER COLOR - حدود الحقول
  static Color textFormBorderColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFD9D9D9),
      dark: const Color(0xFF475569),
      listen: listen,
    );
  }

  // =========== SEMANTIC COLORS ===========
  /// SUCCESS COLOR - للنجاح والإنجازات
  static Color successColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF10B981),
      dark: const Color(0xFF34D399),
      listen: listen,
    );
  }

  /// WARNING COLOR - للتحذيرات
  static Color warningColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFF59E0B),
      dark: const Color(0xFFFBBF24),
      listen: listen,
    );
  }

  /// ERROR COLOR - للأخطاء
  static Color errorColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFEF4444),
      dark: const Color(0xFFF87171),
      listen: listen,
    );
  }

  /// INFO COLOR - للمعلومات
  static Color infoColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF3B82F6),
      dark: const Color(0xFF60A5FA),
      listen: listen,
    );
  }

  // =========== COMPONENT SPECIFIC COLORS ===========
  /// APPBAR COLOR - خلفية الشريط العلوي
  static Color appBarColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: Colors.white,
      dark: const Color(0xFF1E293B),
      listen: listen,
    );
  }

  /// APPBAR TEXT COLOR - نص الشريط العلوي
  static Color appBarTextColor(BuildContext context, {bool listen = true}) {
    return textColor(context, listen: listen);
  }

  /// BUTTON TEXT COLOR - نص الأزرار
  static Color buttonTextColor(BuildContext context, {bool listen = true}) {
    return Colors.white;
  }

  /// BUTTON SECONDARY TEXT COLOR - نص الأزرار الثانوية
  static Color buttonSecondaryTextColor(BuildContext context, {bool listen = true}) {
    return primaryColor(context, listen: listen);
  }

  // =========== UTILITY COLORS ===========
  /// WHITE COLOR - الأبيض
  static Color whiteColor(BuildContext context, {bool listen = true}) {
    return Colors.white;
  }

  /// BLACK COLOR - الأسود
  static Color blackColor(BuildContext context, {bool listen = true}) {
    return Colors.black;
  }

  /// GREY COLOR - الرمادي
  static Color greyColor(BuildContext context, {bool listen = true}) {
    return textSecondary(context, listen: listen);
  }

  /// SHADOW COLOR - للظلال
  static Color shadowColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: Colors.black.withOpacity(0.1),
      dark: Colors.black.withOpacity(0.3),
      listen: listen,
    );
  }

  // =========== ICON COLORS ===========
  /// ICON COLOR - لون الأيقونات
  static Color iconColor(BuildContext context, {bool listen = true}) {
    return textSecondary(context, listen: listen);
  }

  /// ICON PRIMARY COLOR - للأيقونات الأساسية
  static Color iconPrimaryColor(BuildContext context, {bool listen = true}) {
    return primaryColor(context, listen: listen);
  }

  // =========== OTHER COLORS ===========
  static Color purpleColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF9C27B0),
      dark: const Color(0xFFD05CE3),
      listen: listen,
    );
  }

  static Color transparentColor(BuildContext context, {bool listen = true}) {
    return Colors.transparent;
  }

  // =========== GREY SHADES ===========
  static Color grey50Color(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFFAFAFA),
      dark: const Color(0xFF1E293B),
      listen: listen,
    );
  }

  static Color grey100Color(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFF5F5F5),
      dark: const Color(0xFF334155),
      listen: listen,
    );
  }

  static Color grey200Color(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFEEEEEE),
      dark: const Color(0xFF475569),
      listen: listen,
    );
  }

  static Color grey300Color(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFE0E0E0),
      dark: const Color(0xFF64748B),
      listen: listen,
    );
  }

  static Color grey400Color(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFBDBDBD),
      dark: const Color(0xFF94A3B8),
      listen: listen,
    );
  }

  static Color grey600Color(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF757575),
      dark: const Color(0xFFCBD5E1),
      listen: listen,
    );
  }

  // =========== NEW UTILITY METHODS ===========

  /// الحصول على لون بناءً على الوضع الحالي (اختصار)
  static Color getColor(BuildContext context, Color light, Color dark, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: light, dark: dark, listen: listen);
  }

  /// هل الوضع الحالي غامق؟
  static bool isDarkMode(BuildContext context, {bool listen = true}) {
    return AppTheme.isDarkMode(context, listen: listen);
  }

  /// هل الوضع الحالي فاتح؟
  static bool isLightMode(BuildContext context, {bool listen = true}) {
    return AppTheme.isLightMode(context, listen: listen);
  }

  /// تبديل الوضع
  static void toggleTheme(BuildContext context) {
    AppTheme.toggleTheme(context);
  }
}
