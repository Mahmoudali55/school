import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/schedule_model.dart';
import 'package:my_template/features/class/presentation/cubit/schedule_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/schedule_state.dart';
import 'package:my_template/features/class/presentation/execution/widget/interactive_schedule_table.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedDay = DateTime.now().weekday - 1; // اليوم الحالي

  final List<String> _days = [
    'الإثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
    'الأحد',
  ];

  final Map<String, String> _englishToArabicDays = {
    'Monday': 'الإثنين',
    'Tuesday': 'الثلاثاء',
    'Wednesday': 'الأربعاء',
    'Thursday': 'الخميس',
    'Friday': 'الجمعة',
    'Saturday': 'السبت',
    'Sunday': 'الأحد',
  };

  @override
  void initState() {
    super.initState();
    final classCode = HiveMethods.getUserClassCode();
    if (classCode.toString().isNotEmpty) {
      context.read<ScheduleCubit>().getScheduleFromApi(int.parse(classCode.toString()));
    }
  }

  Map<String, List<ScheduleModel>> _groupScheduleByDay(List<ScheduleModel> scheduleList) {
    final Map<String, List<ScheduleModel>> grouped = {};
    for (var day in _days) {
      grouped[day] = [];
    }
    for (var item in scheduleList) {
      final arabicDay = _englishToArabicDays[item.day] ?? item.day;
      if (grouped.containsKey(arabicDay)) {
        grouped[arabicDay]!.add(item);
      }
    }
    // Sort items by period in each day
    for (var day in grouped.keys) {
      grouped[day]!.sort((a, b) => a.period.compareTo(b.period));
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        if (state.getScheduleApiStatus.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state.getScheduleApiStatus.isFailure) {
          return Scaffold(
            appBar: CustomAppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context),
              ),
              context,
              title: Text(AppLocalKay.schedules.tr()),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.getScheduleApiStatus.error ?? AppLocalKay.somethingWentWrong.tr()),
                  Gap(16.h),
                  ElevatedButton(
                    onPressed: () {
                      final classCode = HiveMethods.getUserClassCode();
                      context.read<ScheduleCubit>().getScheduleFromApi(
                        int.parse(classCode.toString()),
                      );
                    },
                    child: Text(AppLocalKay.retry.tr()),
                  ),
                ],
              ),
            ),
          );
        }

        final scheduleData = _groupScheduleByDay(state.getScheduleApiStatus.data ?? []);

        return Scaffold(
          appBar: CustomAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            context,
            title: Text(
              AppLocalKay.schedules.tr(),
              style: AppTextStyle.titleLarge(context).copyWith(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _viewMonthlySchedule(scheduleData),
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              final isLandscape = constraints.maxWidth > constraints.maxHeight;

              if (isLandscape) {
                final classCode = HiveMethods.getUserClassCode();
                return Padding(
                  padding: EdgeInsets.all(16.w),
                  child: InteractiveScheduleTable(
                    className: AppLocalKay.schedules.tr(),
                    startTime: state.startTime,
                    periodsCount: state.periodsCount,
                    periodDuration: state.periodDuration,
                    breakDuration: state.breakDuration,
                    thursdayPeriodsCount: state.thursdayPeriodsCount,
                    breakAfterPeriod: state.breakAfterPeriod,
                    classCode: int.tryParse(classCode.toString()) ?? 0,
                    isReadOnly: true,
                  ),
                );
              }

              return Column(
                children: [
                  // أيام الأسبوع
                  SizedBox(
                    height: 70.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: _days.length,
                      itemBuilder: (context, index) {
                        final dayName = _days[index];
                        final count = scheduleData[dayName]?.length ?? 0;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDay = index;
                            });
                          },
                          child: Container(
                            width: 80.w,
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            decoration: BoxDecoration(
                              color: _selectedDay == index
                                  ? AppColor.primaryColor(context)
                                  : AppColor.grey100Color(context),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dayName,
                                  style: AppTextStyle.bodySmall(context).copyWith(
                                    color: _selectedDay == index
                                        ? AppColor.whiteColor(context)
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Gap(4.h),
                                Text(
                                  '$count',
                                  style: AppTextStyle.bodySmall(context).copyWith(
                                    color: _selectedDay == index
                                        ? AppColor.whiteColor(context)
                                        : Colors.grey,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Gap(16.h),

                  // جدول اليوم
                  Expanded(child: _buildDaySchedule(_days[_selectedDay], scheduleData)),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDaySchedule(String day, Map<String, List<ScheduleModel>> scheduleData) {
    final daySchedule = scheduleData[day] ?? [];

    if (daySchedule.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 60.w, color: Colors.grey),
            Gap(16.h),
            Text(
              AppLocalKay.no_classes_today.tr(),
              style: AppTextStyle.titleMedium(context).copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: daySchedule.length,
      itemBuilder: (context, index) {
        return _buildScheduleItem(daySchedule[index]);
      },
    );
  }

  Widget _buildScheduleItem(ScheduleModel item) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        leading: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: AppColor.primaryColor(context).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.school, color: AppColor.primaryColor(context)),
        ),
        title: Text(
          item.subjectName,
          style: AppTextStyle.titleSmall(context).copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(4.h),
            Text('${item.startTime} - ${item.endTime}'),
            Gap(2.h),
            Text('${AppLocalKay.teachers.tr()}: ${item.teacherName}'),
            Gap(2.h),
            Text('${AppLocalKay.room.tr()}: ${item.room ?? "-"}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () => _setClassReminder(item),
        ),
      ),
    );
  }

  void _viewMonthlySchedule(Map<String, List<ScheduleModel>> scheduleData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalKay.monthly_schedule.tr(),
          style: AppTextStyle.bodyMedium(context).copyWith(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _days.length,
            itemBuilder: (context, index) {
              final dayName = _days[index];
              final count = scheduleData[dayName]?.length ?? 0;
              return ListTile(
                title: Text(dayName),
                subtitle: Text('$count ${AppLocalKay.class_count.tr()}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  setState(() {
                    _selectedDay = index;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _setClassReminder(ScheduleModel item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم ضبط منبه لحصة ${item.subjectName}'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
