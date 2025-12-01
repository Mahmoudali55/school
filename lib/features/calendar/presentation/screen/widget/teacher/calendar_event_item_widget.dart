import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';

class CalendarEventItemWidget extends StatelessWidget {
  final TeacherCalendarEvent task;

  const CalendarEventItemWidget({super.key, required this.task});

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
            decoration: BoxDecoration(color: task.color, shape: BoxShape.circle),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: AppTextStyle.bodyMedium(context, color: AppColor.blackColor(context)),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Text(
                      task.className,
                      style: AppTextStyle.bodySmall(context, color: AppColor.accentColor(context)),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "${_formatDate(task.date)} • ${task.formattedTime}",
                      style: AppTextStyle.bodyMedium(context, color: AppColor.greyColor(context)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: task.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(task.typeName, style: AppTextStyle.bodySmall(context, color: task.color)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    List<String> months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}
