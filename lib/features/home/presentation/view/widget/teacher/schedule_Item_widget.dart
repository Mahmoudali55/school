import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/class/data/model/schedule_Item_model.dart';

class ScheduleItemWidget extends StatelessWidget {
  final ScheduleItem item;
  const ScheduleItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: const Color(0xFFE5E7EB), width: 1)),
        color: item.isCurrent ? const Color(0xFFEFF6FF) : Colors.white,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: item.isCurrent ? const Color(0xFF2E5BFF) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              item.time,
              style: AppTextStyle.bodySmall(
                context,
                color: item.isCurrent ? Colors.white : const Color(0xFF6B7280),
              ).copyWith(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.subject,
                  style: AppTextStyle.titleMedium(
                    context,
                    color: const Color(0xFF1F2937),
                  ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.class_, size: 14.w, color: const Color(0xFF6B7280)),
                    SizedBox(width: 4.w),
                    Text(
                      item.classroom,
                      style: AppTextStyle.bodySmall(
                        context,
                        color: const Color(0xFF6B7280),
                      ).copyWith(fontSize: 12.sp),
                    ),
                    SizedBox(width: 12.w),
                    Icon(Icons.room, size: 14.w, color: const Color(0xFF6B7280)),
                    SizedBox(width: 4.w),
                    Text(
                      item.room,
                      style: AppTextStyle.bodySmall(
                        context,
                        color: const Color(0xFF6B7280),
                      ).copyWith(fontSize: 12.sp),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (item.isCurrent)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "الآن",
                style: AppTextStyle.bodySmall(
                  context,
                  color: Colors.white,
                ).copyWith(fontSize: 10.sp, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
