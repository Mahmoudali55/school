import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_calendar_models.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/parent/parent_event_widgets.dart';

class ParentDailyView extends StatelessWidget {
  final DateTime selectedDate;
  final List<ParentCalendarEvent> dailyEvents;
  final String Function(DateTime) getFormattedDate;

  const ParentDailyView({
    super.key,
    required this.selectedDate,
    required this.dailyEvents,
    required this.getFormattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // تاريخ اليوم
          _buildDailyHeader(context, dailyEvents.length),
          SizedBox(height: 16.h),
          // قائمة الأحداث
          if (dailyEvents.isEmpty)
            const ParentEmptyState()
          else
            Column(
              children: dailyEvents
                  .map((event) => ParentEventCard(event: event))
                  .toList(),
            ),
          SizedBox(height: 20.h),
          // ملاحظات اليوم
          _buildDailyNotes(context),
        ],
      ),
    );
  }

  Widget _buildDailyHeader(BuildContext context, int eventCount) {
    return Container(
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
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.today_rounded,
              color: const Color(0xFF2196F3),
              size: 24.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getFormattedDate(selectedDate),
                  style: AppTextStyle.titleMedium(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "$eventCount أحداث مجدولة لليوم",
                  style: AppTextStyle.bodySmall(
                    context,
                  ).copyWith(color: const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyNotes(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalKay.daily_notes.tr(),
            style: AppTextStyle.titleMedium(context).copyWith(
              color: AppColor.whiteColor(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          _buildNoteRow(
            context,
            Icons.info_outline_rounded,
            "يرجى إحضار الأدوات الفنية لمحمد غداً",
          ),
          SizedBox(height: 8.h),
          _buildNoteRow(
            context,
            Icons.notification_important_rounded,
            "موعد اجتماع أولياء الأمور لليلي الساعة ١ ظهراً",
          ),
          SizedBox(height: 8.h),
          _buildNoteRow(
            context,
            Icons.check_circle_outline_rounded,
            "تم استكمال متطلبات الرحلة المدرسية لأحمد",
          ),
        ],
      ),
    );
  }

  Widget _buildNoteRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColor.whiteColor(context).withOpacity(0.8),
          size: 16.w,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyle.bodySmall(
              context,
            ).copyWith(color: AppColor.whiteColor(context).withOpacity(0.9)),
          ),
        ),
      ],
    );
  }
}
