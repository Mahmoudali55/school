import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const ProfileInfoRow({super.key, required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF2E3192).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: const Color(0xFF2E3192), size: 22.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4.h),
                Text(
                  value == "null" || value.isEmpty ? "-" : value,
                  style: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(fontWeight: FontWeight.w700, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
