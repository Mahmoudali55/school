import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/admin_calendar_models.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/admin/event_widgets.dart';

class DailyView extends StatelessWidget {
  final DateTime selectedDate;
  final List<AdminCalendarEvent> dailyEvents;
  final Function(DateTime) onDateSelected;
  final String Function(DateTime) getFormattedDate;
  final Function(AdminCalendarEvent) onEditEvent;
  final Function(AdminCalendarEvent) onSetReminder;
  final Function(AdminCalendarEvent) onShareEvent;

  const DailyView({
    super.key,
    required this.selectedDate,
    required this.dailyEvents,
    required this.onDateSelected,
    required this.getFormattedDate,
    required this.onEditEvent,
    required this.onSetReminder,
    required this.onShareEvent,
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
            const CalendarEmptyState()
          else
            Column(
              children: dailyEvents
                  .map(
                    (event) => EventCard(
                      event: event,
                      onEdit: () => onEditEvent(event),
                      onSetReminder: () => onSetReminder(event),
                      onShare: () => onShareEvent(event),
                    ),
                  )
                  .toList(),
            ),
          SizedBox(height: 20.h),
          // ملخص اليوم
          _buildDailySummary(context),
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
              color: const Color(0xFF9C27B0).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.today_rounded, color: const Color(0xFF9C27B0), size: 24.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getFormattedDate(selectedDate),
                  style: AppTextStyle.titleMedium(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
                ),
                SizedBox(height: 2.h),
                Text(
                  "$eventCount أحداث مجدولة لليوم",
                  style: AppTextStyle.bodySmall(context).copyWith(color: const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailySummary(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9C27B0).withOpacity(0.3),
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
            style: AppTextStyle.titleMedium(
              context,
            ).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          _buildSummaryRow(
            context,
            Icons.check_circle_outline_rounded,
            "تم إنجاز ٢ من الأحداث اليوم",
          ),
          SizedBox(height: 8.h),
          _buildSummaryRow(
            context,
            Icons.notification_important_rounded,
            "يوجد حدث هام سيبدأ بعد ساعة",
          ),
          SizedBox(height: 8.h),
          _buildSummaryRow(
            context,
            Icons.people_outline_rounded,
            "إجمالي عدد المشاركين اليوم: ٤٥ شخص",
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColor.whiteColor(context).withOpacity(0.8), size: 16.w),
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
