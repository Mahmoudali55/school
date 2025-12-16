import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class QuickOverviewWidget extends StatelessWidget {
  const QuickOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF334155)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _OverviewItem(value: "4", label: "حافلات"),
          _OverviewItem(value: "120", label: "طلاب"),
          _OverviewItem(value: "94%", label: "حضور"),
          _OverviewItem(value: "3/4", label: "نشطة"),
        ],
      ),
    );
  }
}

class _OverviewItem extends StatelessWidget {
  final String value;
  final String label;

  const _OverviewItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyle.titleMedium(context)),
        Text(label, style: AppTextStyle.bodySmall(context)),
      ],
    );
  }
}
