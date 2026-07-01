import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

/// Centralizes status <-> color/text/date mapping for pick up requests
/// so it isn't duplicated across widgets.
class PickUpStatusHelper {
  const PickUpStatusHelper._();

  // 0 = pending, 1 = ready, 2 = preparing, 4 = picked up
  static Color colorOf(int flag, BuildContext context) {
    switch (flag) {
      case 0:
        return const Color(0xFFFF9F1C);
      case 2:
        return const Color(0xFF2EC4B6);
      case 1:
        return const Color(0xFF20BF55);
      case 4:
        return const Color(0xFFE71D36);
      default:
        return AppColor.primaryColor(context);
    }
  }

  static String textOf(int flag) {
    switch (flag) {
      case 0:
        return AppLocalKay.status_pending.tr();
      case 2:
        return AppLocalKay.status_preparing.tr();
      case 1:
        return AppLocalKay.status_ready.tr();
      case 4:
        return AppLocalKay.status_picked_up.tr();
      default:
        return AppLocalKay.status_pending.tr();
    }
  }

  static String formatTime(String transDate) {
    try {
      final DateTime dt = DateTime.parse(transDate);
      return DateFormat('hh:mm a').format(dt);
    } catch (e) {
      return transDate;
    }
  }
}
