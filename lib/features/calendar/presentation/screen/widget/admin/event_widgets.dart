import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/admin_calendar_models.dart';

class EventCard extends StatelessWidget {
  final AdminCalendarEvent event;
  final VoidCallback onEdit;
  final VoidCallback onSetReminder;
  final VoidCallback onShare;

  const EventCard({
    super.key,
    required this.event,
    required this.onEdit,
    required this.onSetReminder,
    required this.onShare,
  });

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
              if (event.priority == "عالي")
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.priority_high_rounded, color: Colors.red, size: 10.w),
                      SizedBox(width: 2.w),
                      Text(
                        "أولوية عالية",
                        style: AppTextStyle.bodySmall(
                          context,
                        ).copyWith(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10.sp),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            event.title,
            style: AppTextStyle.titleMedium(
              context,
            ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 14.w, color: const Color(0xFF6B7280)),
              SizedBox(width: 4.w),
              Text(
                event.time,
                style: AppTextStyle.bodySmall(context).copyWith(color: const Color(0xFF6B7280)),
              ),
              SizedBox(width: 16.w),
              Icon(Icons.location_on_outlined, size: 14.w, color: const Color(0xFF6B7280)),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  event.location,
                  style: AppTextStyle.bodySmall(context).copyWith(color: const Color(0xFF6B7280)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (event.description.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Text(
              event.description,
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(color: const Color(0xFF4B5563), height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          SizedBox(height: 12.h),
          const Divider(),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // المشاركون
              SizedBox(
                height: 24.h,
                child: Stack(
                  children: List.generate(
                    event.participants.length > 3 ? 3 : event.participants.length,
                    (index) => Positioned(
                      left: index * 16.w,
                      child: Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor(context).withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColor.whiteColor(context), width: 1.5),
                        ),
                        child: Center(child: Icon(Icons.person_outline_rounded, size: 12.w)),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit_outlined, size: 18.w, color: const Color(0xFF6B7280)),
                    onPressed: onEdit,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.all(4.w),
                  ),
                  SizedBox(width: 4.w),
                  IconButton(
                    icon: Icon(
                      Icons.notifications_active_outlined,
                      size: 18.w,
                      color: const Color(0xFF6B7280),
                    ),
                    onPressed: onSetReminder,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.all(4.w),
                  ),
                  SizedBox(width: 4.w),
                  IconButton(
                    icon: Icon(Icons.share_outlined, size: 18.w, color: const Color(0xFF6B7280)),
                    onPressed: onShare,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.all(4.w),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CalendarEmptyState extends StatelessWidget {
  const CalendarEmptyState({super.key});

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
                color: const Color(0xFF9C27B0).withOpacity(0.3),
                size: 48.w,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "لا توجد أحداث اليوم",
              style: AppTextStyle.titleMedium(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF4B5563)),
            ),
            SizedBox(height: 8.h),
            Text(
              "استغل هذا الوقت في التخطيط أو إنجاز مهام أخرى",
              textAlign: TextAlign.center,
              style: AppTextStyle.bodySmall(context).copyWith(color: const Color(0xFF6B7280)),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9C27B0),
                foregroundColor: AppColor.whiteColor(context),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              ),
              child: Text(AppLocalKay.new_event.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
