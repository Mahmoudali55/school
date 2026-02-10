import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_state.dart';

import 'api_event_item_widget.dart';

class UpcomingTasksWidget extends StatelessWidget {
  const UpcomingTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        if (state.getEventsStatus.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final events = state.getEventsStatus.data?.events ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalKay.upcoming.tr(),
                  style: AppTextStyle.titleMedium(context).copyWith(color: const Color(0xFF1F2937)),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            if (events.isEmpty)
              _buildEmptyTasks(context)
            else
              Column(
                children: events.take(5).map((event) => ApiEventItemWidget(event: event)).toList(),
              ),
          ],
        );
      },
    );
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
            style: AppTextStyle.bodyMedium(context).copyWith(color: AppColor.greyColor(context)),
          ),
        ],
      ),
    );
  }
}
