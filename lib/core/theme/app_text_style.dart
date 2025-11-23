import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class AppTextStyle {
  // =========== DISPLAY TEXT STYLES ===========
  /// Display Large - للنصوص الكبيرة جداً
  static TextStyle displayLarge(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.w700,
      color: color ?? AppColor.textColor(context, listen: listen),
    );
  }

  /// Display Medium - للعناوين الرئيسية
  static TextStyle displayMedium(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 28.sp,
      fontWeight: FontWeight.w700,
      color: color ?? AppColor.textColor(context, listen: listen),
    );
  }

  /// Display Small - للعناوين الفرعية
  static TextStyle displaySmall(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w600,
      color: color ?? AppColor.textColor(context, listen: listen),
    );
  }

  // =========== HEADLINE TEXT STYLES ===========
  /// Headline Large - للعناوين الكبيرة
  static TextStyle headlineLarge(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w600,
      color: color ?? AppColor.textColor(context, listen: listen),
    );
  }

  /// Headline Medium - للعناوين المتوسطة
  static TextStyle headlineMedium(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: color ?? AppColor.textColor(context, listen: listen),
    );
  }

  /// Headline Small - للعناوين الصغيرة
  static TextStyle headlineSmall(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: color ?? AppColor.textColor(context, listen: listen),
    );
  }

  // =========== TITLE TEXT STYLES ===========
  /// Title Large - للعناوين في الكروت
  static TextStyle titleLarge(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.textColor(context, listen: listen),
    );
  }

  /// Title Medium - لعناوين الأقسام
  static TextStyle titleMedium(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.textColor(context, listen: listen),
    );
  }

  /// Title Small - للعناوين الثانوية
  static TextStyle titleSmall(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.textColor(context, listen: listen),
    );
  }

  // =========== BODY TEXT STYLES ===========
  /// Body Large - للنص الأساسي الكبير
  static TextStyle bodyLarge(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: color ?? AppColor.textColor(context, listen: listen),
    );
  }

  /// Body Medium - للنص الأساسي
  static TextStyle bodyMedium(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: color ?? AppColor.textColor(context, listen: listen),
    );
  }

  /// Body Small - للنص الثانوي
  static TextStyle bodySmall(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: color ?? AppColor.textSecondary(context, listen: listen),
    );
  }

  // =========== LABEL TEXT STYLES ===========
  /// Label Large - لتسميات الأزرار
  static TextStyle labelLarge(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.buttonTextColor(context, listen: listen),
    );
  }

  /// Label Medium - للتسميات المتوسطة
  static TextStyle labelMedium(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.textColor(context, listen: listen),
    );
  }

  /// Label Small - للتسميات الصغيرة
  static TextStyle labelSmall(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.textSecondary(context, listen: listen),
    );
  }

  // =========== COMPONENT SPECIFIC STYLES ===========
  /// AppBar Style - لنص شريط التطبيق
  static TextStyle appBarStyle(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: color ?? AppColor.appBarTextColor(context, listen: listen),
    );
  }

  /// Button Style - لنص الأزرار الأساسية
  static TextStyle buttonStyle(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: color ?? AppColor.buttonTextColor(context, listen: listen),
    );
  }

  /// Button Secondary Style - لنص الأزرار الثانوية
  static TextStyle buttonSecondaryStyle(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: color ?? AppColor.primaryColor(context, listen: listen),
    );
  }

  // =========== FORM TEXT STYLES =========== 
  /// Text Form Style - لنص حقول الإدخال
  static TextStyle textFormStyle(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: color ?? AppColor.textColor(context, listen: listen),
    );
  }

  /// Form Title Style - لعناوين النماذج
  static TextStyle formTitleStyle(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.textColor(context, listen: listen),
    );
  }

  /// Form Hint Style - لنص التلميحات
  static TextStyle formHintStyle(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: color ?? AppColor.hintColor(context, listen: listen),
    );
  }

  // =========== SPECIAL TEXT STYLES ===========
  /// Primary Color Text - للنصوص باللون الأساسي
  static TextStyle primaryText(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.primaryColor(context, listen: listen),
    );
  }

  /// Secondary Color Text - للنصوص باللون الثانوي
  static TextStyle secondaryText(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.secondAppColor(context, listen: listen),
    );
  }

  /// Accent Color Text - للنصوص باللون المميز
  static TextStyle accentText(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.accentColor(context, listen: listen),
    );
  }

  /// Success Color Text - للنصوص بالإنجازات
  static TextStyle successText(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.successColor(context, listen: listen),
    );
  }

  /// Error Color Text - لنصوص الأخطاء
  static TextStyle errorText(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.errorColor(context, listen: listen),
    );
  }

  /// Warning Color Text - لنصوص التحذيرات
  static TextStyle warningText(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.warningColor(context, listen: listen),
    );
  }

  // =========== LEGACY STYLES (للتوافق مع الكود القديم) ===========
  /// Legacy: text16SDark
  static TextStyle text16SDark(BuildContext context, {bool listen = true, Color? color}) {
    return headlineSmall(context, listen: listen, color: color);
  }

  /// Legacy: text14MPrimary
  static TextStyle text14MPrimary(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: color ?? AppColor.primaryColor(context, listen: listen),
    );
  }

  /// Legacy: text16MSecond
  static TextStyle text16MSecond(BuildContext context, {bool listen = true, Color? color}) {
    return secondaryText(context, listen: listen, color: color);
  }

  /// Legacy: text14RGrey
  static TextStyle text14RGrey(BuildContext context, {bool listen = true, Color? color}) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: color ?? AppColor.textSecondary(context, listen: listen),
    );
  }

  /// Legacy: formTitle20Style
  static TextStyle formTitle20Style(BuildContext context, {bool listen = true, Color? color}) {
    return headlineMedium(context, listen: listen, color: color);
  }

  /// Legacy: mainAppColor
  static TextStyle mainAppColor(BuildContext context, {bool listen = true, Color? color}) {
    return primaryText(context, listen: listen, color: color);
  }

  /// Legacy: hintStyle
  static TextStyle hintStyle(BuildContext context, {bool listen = true, Color? color}) {
    return formHintStyle(context, listen: listen, color: color);
  }
}
