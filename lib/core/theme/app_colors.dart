import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppColor {
  /// PRIMARY COLOR (#2E7D32)
  static Color primaryColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF2E7D32),
      dark: const Color(0xFF2E7D32),
      listen: listen,
    );
  }

  /// SECONDARY COLOR (#81C784)
  static Color secondAppColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF81C784),
      dark: const Color(0xFF81C784),
      listen: listen,
    );
  }

  /// ACCENT COLOR (#4FC3F7)
  static Color accentColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF4FC3F7),
      dark: const Color(0xFF4FC3F7),
      listen: listen,
    );
  }

  /// BACKGROUND COLOR (#FAFAFA)
  static Color scaffoldColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFFAFAFA),
      dark: const Color(0xFFFAFAFA),
      listen: listen,
    );
  }

  /// TEXT COLOR (#1E293B)
  static Color textColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF1E293B),
      dark: const Color(0xFF1E293B),
      listen: listen,
    );
  }

  /// HINT COLOR (رمادي خفيف)
  static Color hintColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFA6A6A6),
      dark: const Color(0xFFA6A6A6),
      listen: listen,
    );
  }

  /// BORDERS
  static Color borderColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFD9D9D9),
      dark: const Color(0xFFD9D9D9),
      listen: listen,
    );
  }

  /// FORM FILL / BACKGROUND INSIDE TEXTFIELDS
  static Color textFormFillColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(context, light: Colors.white, dark: Colors.white, listen: listen);
  }

  /// TITLES
  static Color titleColor(BuildContext context, {bool listen = true}) {
    return textColor(context, listen: listen);
  }

  /// GREY TEXT COLOR
  static Color greyColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF616161),
      dark: const Color(0xFF616161),
      listen: listen,
    );
  }

  /// WHITE
  static Color whiteColor(BuildContext context, {bool listen = true}) {
    return Colors.white;
  }

  /// APPBAR COLORS
  static Color appBarColor(BuildContext context, {bool listen = true}) {
    return scaffoldColor(context, listen: listen);
  }

  static Color appBarTextColor(BuildContext context, {bool listen = true}) {
    return textColor(context, listen: listen);
  }

  /// BUTTON TEXT
  static Color buttonTextColor(BuildContext context, {bool listen = true}) {
    return Colors.white;
  }

  static Color textFormBorderColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFD9D9D9),
      dark: const Color(0xFFCCCCCC),
      listen: listen,
    );
  }
}
