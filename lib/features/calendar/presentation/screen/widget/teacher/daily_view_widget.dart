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

class DailyViewWidget extends StatelessWidget {
  const DailyViewWidget({super.key});

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
              Gap(8.h),
              _buildDailyHeader(state, events.length, context: context),
              Gap(24.h),
              if (events.isEmpty)
                _buildEmptySchedule(context)
              else
                Column(children: events.map((event) => ApiEventItemWidget(event: event)).toList()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDailyHeader(CalendarState state, int eventCount, {required BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColor.accentColor(context).withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColor.accentColor(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.today_rounded, color: AppColor.accentColor(context), size: 20.w),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getFormattedDate(state.selectedDate),
                  style: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(color: AppColor.blackColor(context)),
                ),
                Gap(5.h),
                Text(
                  _getDayName(state.selectedDate.weekday),
                  style: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(color: AppColor.greyColor(context)),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$eventCount حدث",
                style: AppTextStyle.bodyMedium(
                  context,
                ).copyWith(color: AppColor.accentColor(context)),
              ),
              Gap(2.h),
              Text(
                "${_getTeachingHours(state)} ساعة تدريس",
                style: AppTextStyle.bodySmall(context).copyWith(color: AppColor.greyColor(context)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getFormattedDate(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getDayName(int weekday) {
    List<String> days = ['أحد', 'اثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت'];
    return days[weekday % 7];
  }

  String _getTeachingHours(CalendarState state) {
    return "0.0";
  }

  Widget _buildEmptySchedule(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.w),
      child: Column(
        children: [
          Icon(Icons.school_outlined, size: 48.w, color: AppColor.greyColor(context)),
          Gap(12.h),
          Text(AppLocalKay.schedule_empty_title.tr(), style: AppTextStyle.titleMedium(context)),
          Gap(4.h),
          Text(
            AppLocalKay.schedule_empty_title2.tr(),
            style: AppTextStyle.bodyMedium(context).copyWith(color: AppColor.greyColor(context)),
          ),
        ],
      ),
    );
  }
}
