// ─── credit_card_validators.dart ────────────────────────────────

import 'package:easy_localization/easy_localization.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class CreditCardValidators {

  // ─── Card Number ─────────────────────────────────────────────

  static String? validateCardNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalKay.cardNumberRequired.tr();
    }

    final digits = value.replaceAll(RegExp(r'\s+'), '');

    if (!RegExp(r'^\d+$').hasMatch(digits)) {
      return AppLocalKay.cardNumberDigitsOnly.tr();
    }

    if (digits.length != 16) {
      return AppLocalKay.cardNumberLength.tr();
    }

    return null;
  }

  // ─── Cardholder Name ─────────────────────────────────────────

  static String? validateCardHolder(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalKay.cardHolderRequired.tr();
    }

    final trimmed = value.trim();

    if (trimmed.length < 3) {
      return AppLocalKay.cardHolderTooShort.tr();
    }

    if (trimmed.length > 26) {
      return AppLocalKay.cardHolderTooLong.tr();
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(trimmed)) {
      return AppLocalKay.cardHolderEnglishOnly.tr();
    }

    if (!trimmed.contains(' ')) {
      return AppLocalKay.cardHolderFullName.tr();
    }

    return null;
  }

  // ─── Expiry Date ─────────────────────────────────────────────

  static String? validateExpiry(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalKay.expiryRequired.tr();
    }

    final trimmed = value.trim();

    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(trimmed)) {
      return AppLocalKay.expiryInvalidFormat.tr();
    }

    final parts = trimmed.split('/');
    final month = int.tryParse(parts[0]);
    final year  = int.tryParse(parts[1]);

    if (month == null || month < 1 || month > 12) {
      return AppLocalKay.expiryInvalidMonth.tr();
    }

    if (year == null) {
      return AppLocalKay.expiryInvalidYear.tr();
    }

    final now          = DateTime.now();
    final currentYear  = now.year % 100;
    final currentMonth = now.month;

    if (year < currentYear) {
      return AppLocalKay.cardExpired.tr();
    }

    if (year == currentYear && month < currentMonth) {
      return AppLocalKay.expiryInvalidYear.tr();
    }

    if (year > currentYear + 20) {
      return AppLocalKay.expiryInvalidYear.tr();
    }

    return null;
  }

  // ─── CVV ─────────────────────────────────────────────────────

  static String? validateCvv(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalKay.cvvRequired.tr();
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return AppLocalKay.cvvDigitsOnly.tr();
    }

    if (value.length != 3 && value.length != 4) {
      return AppLocalKay.cvvInvalidLength.tr();
    }

    return null;
  }
}