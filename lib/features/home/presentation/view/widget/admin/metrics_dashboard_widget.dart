import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/metric_card_model.dart';
import 'package:my_template/features/home/presentation/view/widget/admin/metric_card_widget.dart';

class MetricsDashboard extends StatelessWidget {
  final List<MetricCard> metrics = [
    MetricCard(
      title: "إجمالي الحضور اليوم",
      value: "94%",
      change: "+2%",
      isPositive: true,
      icon: Icons.people,
      color: Color(0xFF10B981),
    ),
    MetricCard(
      title: "عدد الطلاب",
      value: "450",
      change: "+15",
      isPositive: true,
      icon: Icons.school,
      color: Color(0xFF2E5BFF),
    ),
    MetricCard(
      title: "عدد المعلمين",
      value: "45",
      change: "+2",
      isPositive: true,
      icon: Icons.person,
      color: Color(0xFFF59E0B),
    ),
    MetricCard(
      title: "الحافلات النشطة",
      value: "8",
      change: "0",
      isPositive: true,
      icon: Icons.directions_bus,
      color: Color(0xFF9C27B0),
    ),
    MetricCard(
      title: "الرسوم المستلمة",
      value: "85%",
      change: "+5%",
      isPositive: true,
      icon: Icons.payments,
      color: Color(0xFFEC4899),
    ),
  ];

  MetricsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalKay.generalView.tr(),
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 150.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: metrics.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) => MetricCardWidget(metric: metrics[index]),
          ),
        ),
      ],
    );
  }
}
