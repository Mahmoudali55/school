import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class PickUpGlowStatus extends StatelessWidget {
  const PickUpGlowStatus({super.key, required this.color, required this.text});

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 0.8),
      ),
      child: Text(
        text,
        style: AppTextStyle.bodySmall(context).copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 9.sp,
        ),
      ),
    );
  }
}
