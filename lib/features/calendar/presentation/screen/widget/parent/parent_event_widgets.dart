import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_calendar_models.dart';

class ParentEventCard extends StatelessWidget {
  final ParentCalendarEvent event;

  const ParentEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: event.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  event.type,
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: event.color, fontWeight: FontWeight.bold, fontSize: 10.sp),
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person_outline_rounded, color: const Color(0xFF2196F3), size: 10.w),
                    SizedBox(width: 4.w),
                    Text(
                      event.student,
                      style: AppTextStyle.bodySmall(context).copyWith(
                        color: const Color(0xFF2196F3),
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Text(
            event.title,
            style: AppTextStyle.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
          ),
          SizedBox(height: 8.h),

          if (event.description.isNotEmpty) ...[
            Text(
              event.description,
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(color: const Color(0xFF4B5563), height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 14.w, color: const Color(0xFF6B7280)),
              SizedBox(width: 4.w),
              Text(
                event.time + " • " + event.date,
                style: AppTextStyle.bodySmall(context).copyWith(color: const Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ParentEmptyState extends StatelessWidget {
  const ParentEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), shape: BoxShape.circle),
              child: Icon(
                Icons.event_available_rounded,
                color: const Color(0xFF2196F3).withOpacity(0.3),
                size: 48.w,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "لا توجد أحداث مجدولة",
              style: AppTextStyle.titleMedium(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF4B5563)),
            ),
            SizedBox(height: 8.h),
            Text(
              "استمتع بيوم هادئ مع أبنائك",
              textAlign: TextAlign.center,
              style: AppTextStyle.bodySmall(context).copyWith(color: const Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}
