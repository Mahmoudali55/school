import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/class/data/model/schedule_Item_model.dart';
import 'package:my_template/features/home/presentation/view/widget/teacher/action_card_widget.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<QuickAction> actions = [
      QuickAction(title: "رفع درس جديد", icon: Icons.upload, color: Color(0xFF2E5BFF)),
      QuickAction(title: "تسجيل الحضور", icon: Icons.people, color: Color(0xFF10B981)),
      QuickAction(title: "إنشاء واجب", icon: Icons.assignment, color: Color(0xFFF59E0B)),
      QuickAction(
        title: "إرسال إشعار",
        icon: Icons.notification_important,
        color: Color(0xFFEC4899),
      ),
      QuickAction(title: "تقرير سلوك", icon: Icons.report, color: Color(0xFFDC2626)),
      QuickAction(title: "التقارير", icon: Icons.analytics, color: Color(0xFF7C3AED)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "الإجراءات السريعة",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 16.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 12.h,
            childAspectRatio: 0.9,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            return ActionCardWidget(action: actions[index]);
          },
        ),
      ],
    );
  }
}
