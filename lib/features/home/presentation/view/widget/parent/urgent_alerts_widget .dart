import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/alert_Item_widget.dart';

class UrgentAlertsWidget extends StatelessWidget {
  const UrgentAlertsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalKay.urgent_notifications.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1F2937),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "٢ جديد",
                style: TextStyle(
                  color: const Color(0xFFDC2626),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Column(
          children: const [
            AlertItem(
              icon: Icons.warning_amber_rounded,
              iconColor: Color(0xFFDC2626),
              iconBgColor: Color(0xFFFEF2F2),
              title: "غياب الطالب اليوم",
              description: "تم تسجيل غياب الطالب اليوم بدون إذن مسبق",
              time: "منذ ساعتين",
              isUrgent: true,
            ),
            SizedBox(height: 12),
            AlertItem(
              icon: Icons.assignment,
              iconColor: Color(0xFF2E5BFF),
              iconBgColor: Color(0xFFEFF6FF),
              title: "تقرير سلوكي جديد",
              description: "تقرير سلوكي إيجابي من معلم الفيزياء",
              time: "منذ يوم",
              isUrgent: false,
            ),
            SizedBox(height: 12),
            AlertItem(
              icon: Icons.message,
              iconColor: Color(0xFF10B981),
              iconBgColor: Color(0xFFD1FAE5),
              title: "رسالة من المعلم",
              description: "يرجى متابعة الواجب المنزلي للطالب",
              time: "منذ ٣ أيام",
              isUrgent: false,
            ),
          ],
        ),
      ],
    );
  }
}
