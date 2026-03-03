import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/schedule_model.dart';
import 'package:my_template/features/class/presentation/cubit/schedule_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/schedule_state.dart';

class HeroNextClassCard extends StatelessWidget {
  const HeroNextClassCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        final scheduleStatus = state.getScheduleApiStatus;

        if (scheduleStatus.isLoading) {
          return Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: AppColor.primaryColor(context).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        ScheduleModel? activeClass;
        ScheduleModel? nextClass;
        final now = DateTime.now();
        final days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
        final currentDay = days[now.weekday % 7];
        final todaySchedules = state.generatedSchedules.where((s) => s.day == currentDay).toList();

        if (todaySchedules.isNotEmpty) {
          todaySchedules.sort((a, b) => a.startTime.compareTo(b.startTime));

          for (var s in todaySchedules) {
            final isBreak =
                s.subjectName.toLowerCase().contains('break') || s.subjectName.contains('فسحة');
            if (isBreak) continue;

            try {
              final timeFormat = DateFormat('HH:mm');
              final startStr = s.startTime.substring(0, 5);
              final endStr = s.endTime.substring(0, 5);
              final start = timeFormat.parse(startStr);
              final end = timeFormat.parse(endStr);
              final current = timeFormat.parse(DateFormat('HH:mm').format(now));

              if (current.isAfter(start) && current.isBefore(end)) {
                activeClass = s;
                break;
              } else if (start.isAfter(current)) {
                nextClass = s;
                break;
              }
            } catch (_) {}
          }
        }

        final displayClass = activeClass ?? nextClass;

        if (displayClass == null) {
          final bool hasClassesToday = todaySchedules.isNotEmpty;
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColor.surfaceColor(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.borderColor(context).withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: (hasClassesToday ? Colors.green : Colors.blue).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    hasClassesToday ? Icons.done_all_rounded : Icons.event_available_rounded,
                    color: hasClassesToday ? Colors.green : Colors.blue,
                    size: 30.w,
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasClassesToday
                            ? AppLocalKay.end_of_class.tr()
                            : AppLocalKay.no_classes_today_schedule.tr(),
                        style: AppTextStyle.titleSmall(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColor.primaryColor(context),
                        ),
                      ),
                      Gap(4.h),
                      Text(
                        hasClassesToday
                            ? AppLocalKay.end_of_day.tr()
                            : AppLocalKay.no_schedule.tr(),
                        style: AppTextStyle.bodySmall(
                          context,
                        ).copyWith(color: AppColor.grey600Color(context)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.secondAppColor(context), AppColor.primaryColor(context)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    activeClass != null ? Icons.play_circle_fill_rounded : Icons.schedule,
                    color: AppColor.whiteColor(context),
                    size: 26.w,
                  ),
                  Gap(8.w),
                  Text(
                    activeClass != null
                        ? AppLocalKay.current_class.tr()
                        : AppLocalKay.join_class.tr(),
                    style: AppTextStyle.bodyLarge(
                      context,
                      color: AppColor.whiteColor(context),
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Gap(16.h),
              Text(
                displayClass.subjectName,
                style: AppTextStyle.headlineSmall(
                  context,
                  color: AppColor.whiteColor(context),
                ).copyWith(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              Gap(8.h),
              Row(
                children: [
                  Icon(Icons.access_time, color: AppColor.whiteColor(context), size: 16.w),
                  Gap(6.w),
                  Text(
                    "${displayClass.startTime.substring(0, 5)} - ${displayClass.endTime.substring(0, 5)}",
                    style: AppTextStyle.bodyMedium(
                      context,
                      color: AppColor.whiteColor(context),
                    ).copyWith(fontSize: 14.sp),
                  ),
                ],
              ),
              Gap(4.h),
              Row(
                children: [
                  Icon(Icons.person, color: AppColor.whiteColor(context), size: 16.w),
                  Gap(6.w),
                  Text(
                    nextClass?.teacherName ?? "",
                    style: AppTextStyle.bodyMedium(
                      context,
                      color: AppColor.whiteColor(context),
                    ).copyWith(fontSize: 14.sp),
                  ),
                ],
              ),
              Gap(20.h),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.video_call, size: 20.w),
                label: Text(
                  AppLocalKay.join_default_class.tr(),
                  style: AppTextStyle.bodyMedium(
                    context,
                  ).copyWith(fontWeight: FontWeight.bold, fontSize: 14.sp),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColor.primaryColor(context),
                  backgroundColor: AppColor.whiteColor(context),
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
