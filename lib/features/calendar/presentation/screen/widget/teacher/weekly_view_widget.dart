import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

import '../../../cubit/calendar_cubit.dart';
import '../../../cubit/calendar_state.dart';
import 'api_event_item_widget.dart';
import 'calender_control_bar.dart';
import 'level_selector_widget.dart';

class WeeklyViewWidget extends StatelessWidget {
  const WeeklyViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        final events = state.getEventsStatus.data?.events ?? [];

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LevelSelectorWidget(),
              const ControlBarWidget(),
              _buildWeekDaySelector(context, state),
              Gap(16.h),
              Text(
                AppLocalKay.upcoming.tr(),
                style: AppTextStyle.titleMedium(
                  context,
                ).copyWith(color: AppColor.blackColor(context), fontWeight: FontWeight.bold),
              ),
              Gap(12.h),
              if (state.getEventsStatus.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (events.isEmpty)
                _buildEmptyTasks(context)
              else
                Column(children: events.map((event) => ApiEventItemWidget(event: event)).toList()),
            ],
          ),
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

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColor.whiteColor(context),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColor.greyColor(context).withOpacity(0.05)),
          ),
          child: SizedBox(
            height: 70.h,
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
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 55.w,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor.accentColor(context)
                          : AppColor.greyColor(context).withOpacity(0.02),
                      borderRadius: BorderRadius.circular(12.r),
                      border: isSelected
                          ? null
                          : Border.all(color: AppColor.greyColor(context).withOpacity(0.1)),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColor.accentColor(context).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getDayName(date.weekday),
                          style: AppTextStyle.bodySmall(context).copyWith(
                            color: isSelected ? Colors.white : AppColor.greyColor(context),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 10.sp,
                          ),
                        ),
                        Gap(4.h),
                        Text(
                          date.day.toString(),
                          style: AppTextStyle.titleMedium(context).copyWith(
                            color: isSelected ? Colors.white : AppColor.blackColor(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
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
          Gap(8.h),
          Text(
            AppLocalKay.no_tasks.tr(),
            style: AppTextStyle.bodyMedium(context).copyWith(color: AppColor.greyColor(context)),
          ),
        ],
      ),
    );
  }
}
