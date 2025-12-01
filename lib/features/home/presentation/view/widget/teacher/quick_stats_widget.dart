import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/presentation/view/widget/teacher/stat_card_widget.dart';

class QuickStatsWidget extends StatelessWidget {
  const QuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCardWidget(
            title: AppLocalKay.todo.tr(),
            value: "5",
            subtitle: AppLocalKay.todo_hint.tr(),
            icon: Icons.assignment,
            color: Color(0xFFF59E0B),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: StatCardWidget(
            title: AppLocalKay.notification.tr(),
            value: "3",
            subtitle: AppLocalKay.week.tr(),
            icon: Icons.notifications,
            color: Color(0xFF10B981),
          ),
        ),
      ],
    );
  }
}
