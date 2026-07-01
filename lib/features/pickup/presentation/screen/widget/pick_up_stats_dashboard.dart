import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/get_automatic_call_model.dart';

import 'pick_up_stat_card.dart';

class PickUpStatsDashboard extends StatelessWidget {
  const PickUpStatsDashboard({super.key, required this.requests});

  final List<AutomaticCallItem> requests;

  @override
  Widget build(BuildContext context) {
    // 0 = pending (معلق), 1 = ready (جاهز للاستلام), 2 = preparing (جاري التجهيز)
    final pendingCount = requests.where((r) => r.flag == 0).length;
    final preparingCount = requests.where((r) => r.flag == 2).length;
    final readyCount = requests.where((r) => r.flag == 1).length;

    return Container(
      height: 95.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          PickUpStatCard(
            label: "الكل",
            value: requests.length.toString(),
            icon: Icons.group_rounded,
            color: const Color(0xFF6366F1),
          ),
          PickUpStatCard(
            label: AppLocalKay.status_pending.tr(),
            value: pendingCount.toString(),
            icon: Icons.hourglass_empty_rounded,
            color: const Color(0xFFFF9F1C),
          ),
          PickUpStatCard(
            label: AppLocalKay.status_preparing.tr(),
            value: preparingCount.toString(),
            icon: Icons.sync_rounded,
            color: const Color(0xFF2EC4B6),
          ),
          PickUpStatCard(
            label: AppLocalKay.status_ready.tr(),
            value: readyCount.toString(),
            icon: Icons.done_all_rounded,
            color: const Color(0xFF20BF55),
          ),
        ],
      ),
    );
  }
}
