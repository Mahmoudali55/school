import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class BusTrackingStatusCardWidget extends StatelessWidget {
  const BusTrackingStatusCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16.w),
              ),
              SizedBox(width: 8.w),
              Text(
                title,
                style: AppTextStyle.bodySmall(
                  context,
                ).copyWith(color: const Color(0xFF6B7280), fontSize: 12.sp),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: AppTextStyle.bodyLarge(context).copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: const Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }
}
