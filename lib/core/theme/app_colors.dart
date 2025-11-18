import 'package:flutter/material.dart';

import 'app_theme.dart';

class AppColor {
  static Color primaryColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xff0B409C),
      dark: const Color(0xff0B409C),
      listen: listen,
    );
  }

  static Color secondAppColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xff23120B),
      dark: const Color(0xff23120B),
      listen: listen,
    );
  }

  static Color borderColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xffA6A6A6),
      dark: const Color(0xffA6A6A6),
      listen: listen,
    );
  }

  static Color scaffoldColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFF9F9F9),
      dark: const Color(0xFFF9F9F9),
      listen: listen,
    );
  }  static Color textFormFillColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFF9F9F9),
      dark: const Color(0xFFF9F9F9),
      listen: listen,
    );
  }

  static Color hintColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xffA6A6A6),
      dark: const Color(0xffA6A6A6),
      listen: listen,
    );
  }

  static Color darkTextColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF616161),
      dark: const Color(0xFF616161),
      listen: listen,
    );
  }

  static Color greyColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFA5A5A5),
      dark: const Color(0xFFA5A5A5),
      listen: listen,
    );
  }

  static Color titleFormFiledColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF000627),
      dark: const Color(0xFF000627),
      listen: listen,
    );
  }

  static Color whiteColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xffffffff),
      dark: const Color(0xffffffff),
      listen: listen,
    );
  }

  static Color textFormBorderColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFFD9D9D9),
      dark: const Color(0xFFD9D9D9),
      listen: listen,
    );
  }

  static Color textFormColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xff000000),
      dark: const Color(0xff000000),
      listen: listen,
    );
  }

  static Color appBarTextColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xFF23120B),
      dark: const Color(0xFF23120B),
      listen: listen,
    );
  }

  static Color appBarColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xffFAFAFA),
      dark: const Color(0xffFAFAFA),
      listen: listen,
    );
  }

  static Color buttonTextColor(BuildContext context, {bool listen = true}) {
    return AppTheme.getByTheme(
      context,
      light: const Color(0xffffffff),
      dark: const Color(0xffffffff),
      listen: listen,
    );
  }
}
