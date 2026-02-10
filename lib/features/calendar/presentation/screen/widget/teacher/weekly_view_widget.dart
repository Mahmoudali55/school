import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

import '../../../cubit/calendar_cubit.dart';
import '../../../cubit/calendar_state.dart';
import 'api_event_item_widget.dart';

class WeeklyViewWidget extends StatelessWidget {
  const WeeklyViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        final events = state.getEventsStatus.data?.events ?? [];

        return Column(
          children: [
            _buildWeekDaySelector(context, state),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalKay.upcoming.tr(),
                      style: AppTextStyle.titleMedium(
                        context,
                      ).copyWith(color: const Color(0xFF1F2937)),
                    ),
                    SizedBox(height: 12.h),
                    if (state.getEventsStatus.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (events.isEmpty)
                      _buildEmptyTasks(context)
                    else
                      Column(
                        children: events.map((event) => ApiEventItemWidget(event: event)).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeekDaySelector(BuildContext context, CalendarState state) {
    // Start of the week (Saturday if we follow common Arabic school week)
    // Or just 3 days before and 3 days after the selected date to keep it scrollable/dynamic
    final days = List.generate(7, (index) {
      final startOfWeek = state.selectedDate.subtract(
        Duration(days: state.selectedDate.weekday % 7),
      );
      return startOfWeek.add(Duration(days: index));
    });

    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        border: Border(bottom: BorderSide(color: AppColor.greyColor(context).withOpacity(0.1))),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        itemBuilder: (context, index) {
          final date = days[index];
          final isSelected = DateUtils.isSameDay(date, state.selectedDate);

          return GestureDetector(
            onTap: () {
              context.read<CalendarCubit>().changeDate(date);
            },
            child: Container(
              width: 50.w,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColor.accentColor(context) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? null
                    : Border.all(color: AppColor.greyColor(context).withOpacity(0.2)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getDayName(date.weekday),
                    style: AppTextStyle.bodySmall(context).copyWith(
                      color: isSelected ? Colors.white : AppColor.greyColor(context),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    date.day.toString(),
                    style: AppTextStyle.titleMedium(context).copyWith(
                      color: isSelected ? Colors.white : AppColor.blackColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDayName(int weekday) {
    List<String> days = ['أحد', 'اثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت'];
    return days[weekday % 7];
  }

  Widget _buildEmptyTasks(BuildContext context) {
    return Container(
      width: double.infinity,
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
