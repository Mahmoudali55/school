import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

extension ContextExtension on BuildContext {
  double width() => MediaQuery.sizeOf(this).width;

  double height() => MediaQuery.sizeOf(this).height;

  String fontFamily() => apiTr(ar: 'Vazirmatn', en: 'Vazirmatn');
  String fontFamilyAr() => 'Vazirmatn';
  String fontFamilyEn() => 'Vazirmatn';

  String apiTr({
    required String ar,
    required String en,
  }) {
    String text = '';
    switch (locale.languageCode) {
      case 'ar':
        text = ar;
        break;
      case 'en':
        text = en;
        break;
    }
    return text;
  }

  dynamic getByLang({
    required dynamic ar,
    required dynamic en,
  }) {
    switch (locale.languageCode) {
      case 'ar':
        return ar;
      case 'en':
        return en;
    }
  }

  void doByLang({
    required VoidCallback ar,
    required VoidCallback en,
  }) {
    switch (locale.languageCode) {
      case 'ar':
        ar.call();
        break;
      case 'en':
        en.call();
        break;
    }
  }

  bool isRTL() {
    return intl.Bidi.isRtlLanguage(locale.languageCode);
  }
}
