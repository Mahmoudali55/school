import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/calendar_event_item_widget.dart';

import '../../../cubit/calendar_cubit.dart';
import '../../../cubit/calendar_state.dart';

class UpcomingTasksWidget extends StatelessWidget {
  const UpcomingTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        final upcomingTasks = _getUpcomingTasks(state);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalKay.upcoming.tr(),
                  style: AppTextStyle.titleMedium(context, color: const Color(0xFF1F2937)),
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: عرض جميع المهام
                  },
                  child: Text(
                    AppLocalKay.show_all.tr(),
                    style: AppTextStyle.bodyMedium(context, color: AppColor.accentColor(context)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            if (upcomingTasks.isEmpty)
              _buildEmptyTasks(context)
            else
              Column(
                children: upcomingTasks
                    .take(5)
                    .map((task) => CalendarEventItemWidget(task: task))
                    .toList(),
              ),
          ],
        );
      },
    );
  }

  List _getUpcomingTasks(CalendarState state) {
    // الحصول على الأحداث القادمة في الأيام السبعة القادمة
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));

    return state.events.where((event) {
      return event.date.isAfter(now.subtract(const Duration(days: 1))) &&
          event.date.isBefore(nextWeek.add(const Duration(days: 1))) &&
          (event.type.name == AppLocalKay.complete.tr() ||
              event.type.name == AppLocalKay.prepare.tr());
    }).toList();
  }

  Widget _buildEmptyTasks(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.assignment_turned_in_outlined, size: 40.w, color: AppColor.greyColor(context)),
          SizedBox(height: 8.h),
          Text(
            AppLocalKay.no_tasks.tr(),
            style: AppTextStyle.bodyMedium(context, color: AppColor.greyColor(context)),
          ),
        ],
      ),
    );
  }
}
