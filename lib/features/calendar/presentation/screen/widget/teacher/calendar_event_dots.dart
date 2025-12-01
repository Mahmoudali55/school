import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';

class CalendarEventDots extends StatelessWidget {
  final List<TeacherCalendarEvent> events;

  const CalendarEventDots({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 2,
      right: 0,
      left: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...events
              .take(3)
              .map(
                (event) => Container(
                  width: 4.w,
                  height: 4.w,
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  decoration: BoxDecoration(color: event.color, shape: BoxShape.circle),
                ),
              )
              .toList(),
          if (events.length > 3)
            Text(
              '+${events.length - 3}',
              style: AppTextStyle.bodyMedium(context, color: AppColor.greyColor(context)),
            ),
        ],
      ),
    );
  }
}
