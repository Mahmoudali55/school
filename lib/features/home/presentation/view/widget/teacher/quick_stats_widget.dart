import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/home/presentation/view/widget/teacher/stat_card_widget.dart';

class QuickStatsWidget extends StatelessWidget {
  const QuickStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCardWidget(
            title: "الواجبات المنتظرة",
            value: "5",
            subtitle: "تحتاج تصحيح",
            icon: Icons.assignment,
            color: Color(0xFFF59E0B),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: StatCardWidget(
            title: "الإشعارات المرسلة",
            value: "3",
            subtitle: "هذا الأسبوع",
            icon: Icons.notifications,
            color: Color(0xFF10B981),
          ),
        ),
      ],
    );
  }
}
