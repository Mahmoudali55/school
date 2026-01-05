import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class NotificationItemWidget extends StatelessWidget {
  const NotificationItemWidget({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.message,
    required this.time,
    required this.isUrgent,
    required this.isRead,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String message;
  final String time;
  final bool isUrgent;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: isUrgent && !isRead ? Border.all(color: const Color(0xFFFEF2F2), width: 2) : null,
      ),
      child: Stack(
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(16.w),
            leading: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20.w),
            ),
            title: Text(
              title,
              style: AppTextStyle.bodyMedium(context).copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: const Color(0xFF1F2937),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                Text(
                  message,
                  style: AppTextStyle.bodySmall(
                    context,
                    color: const Color(0xFF6B7280),
                  ).copyWith(fontSize: 12.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  time,
                  style: AppTextStyle.bodySmall(
                    context,
                    color: const Color(0xFF9CA3AF),
                  ).copyWith(fontSize: 10.sp),
                ),
              ],
            ),
            trailing: Icon(Icons.chevron_left, color: const Color(0xFFD1D5DB), size: 20.w),
          ),
          if (isUrgent && !isRead)
            Positioned(
              top: 12.h,
              right: 12.w,
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(color: Color(0xFFDC2626), shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }
}
