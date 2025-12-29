import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/student/student_calendar_models.dart';

class StudentEventCard extends StatelessWidget {
  final StudentCalendarEvent event;

  const StudentEventCard({super.key, required this.event});

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
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 40.h,
            decoration: BoxDecoration(color: event.color, borderRadius: BorderRadius.circular(2)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF1F2937)),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 12.w, color: const Color(0xFF6B7280)),
                    SizedBox(width: 4.w),
                    Text(
                      event.time,
                      style: AppTextStyle.bodySmall(
                        context,
                      ).copyWith(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                    ),
                    SizedBox(width: 12.w),
                    Icon(Icons.location_on_rounded, size: 12.w, color: const Color(0xFF6B7280)),
                    SizedBox(width: 4.w),
                    Text(
                      event.location,
                      style: AppTextStyle.bodySmall(
                        context,
                      ).copyWith(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                    ),
                  ],
                ),
                if (event.description.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Text(
                    event.description,
                    style: AppTextStyle.bodySmall(
                      context,
                    ).copyWith(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
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
              ).copyWith(fontSize: 10.sp, color: event.color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class StudentUpcomingEventItem extends StatelessWidget {
  final StudentCalendarEvent event;

  const StudentUpcomingEventItem({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.03),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(color: event.color, shape: BoxShape.circle),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF1F2937)),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${event.date} • ${event.time}",
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: event.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              event.type,
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(fontSize: 9.sp, color: event.color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class StudentEmptyState extends StatelessWidget {
  const StudentEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: [
          Icon(Icons.event_available_rounded, size: 48.w, color: const Color(0xFF9CA3AF)),
          SizedBox(height: 12.h),
          Text(
            AppLocalKay.no_events.tr(),
            style: AppTextStyle.bodyMedium(
              context,
            ).copyWith(color: const Color(0xFF6B7280), fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4.h),
          Text(
            AppLocalKay.no_events_today.tr(),
            style: AppTextStyle.bodySmall(context).copyWith(color: const Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }
}
