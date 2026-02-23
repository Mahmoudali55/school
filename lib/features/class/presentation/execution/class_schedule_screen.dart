// features/class/presentation/execution/class_schedule_screen.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/services/services_locator.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/schedule_model.dart';
import 'package:my_template/features/class/data/model/school_class_model.dart';
import 'package:my_template/features/class/presentation/cubit/schedule_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/schedule_state.dart';

class ClassScheduleScreen extends StatefulWidget {
  final SchoolClass schoolClass;

  const ClassScheduleScreen({super.key, required this.schoolClass});

  @override
  State<ClassScheduleScreen> createState() => _ClassScheduleScreenState();
}

class _ClassScheduleScreenState extends State<ClassScheduleScreen> {
  int _selectedDay = 0;

  final List<String> _daysEn = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'];
  final List<String> _daysAr = ['الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ScheduleCubit>()..getScheduleFromApi(int.tryParse(widget.schoolClass.id) ?? 0),
      child: Scaffold(
        appBar: CustomAppBar(
          context,
          title: Text(
            '${AppLocalKay.schedules.tr()}  ${widget.schoolClass.name}',
            style: AppTextStyle.titleLarge(
              context,
              color: AppColor.blackColor(context),
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColor.blackColor(context)),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
        ),
        body: BlocBuilder<ScheduleCubit, ScheduleState>(
          builder: (context, state) {
            if (state.getScheduleApiStatus.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.getScheduleApiStatus.isFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off_rounded, size: 64.w, color: Colors.grey),
                    Gap(16.h),
                    Text(
                      AppLocalKay.schedule_empty_title.tr(),
                      style: AppTextStyle.titleMedium(context),
                    ),
                    Gap(8.h),
                    Text(
                      state.getScheduleApiStatus.error ?? '',
                      style: AppTextStyle.bodySmall(context),
                      textAlign: TextAlign.center,
                    ),
                    Gap(16.h),
                    ElevatedButton.icon(
                      onPressed: () => context.read<ScheduleCubit>().getScheduleFromApi(
                        int.tryParse(widget.schoolClass.id) ?? 0,
                      ),
                      icon: const Icon(Icons.refresh),
                      label: Text(AppLocalKay.retry.tr()),
                    ),
                  ],
                ),
              );
            }

            final schedule = state.getScheduleApiStatus.data ?? [];

            if (schedule.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, size: 64.w, color: Colors.grey),
                    Gap(16.h),
                    Text(
                      AppLocalKay.schedule_empty_title.tr(),
                      style: AppTextStyle.titleMedium(context),
                    ),
                    Gap(8.h),
                    Text(
                      AppLocalKay.schedule_empty_subtitle.tr(),
                      style: AppTextStyle.bodySmall(context),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // أيام الأسبوع
                SizedBox(
                  height: 60.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _daysAr.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                        child: ChoiceChip(
                          label: Text(_daysAr[index]),
                          selected: _selectedDay == index,
                          onSelected: (selected) {
                            setState(() {
                              _selectedDay = index;
                            });
                          },
                          selectedColor: Colors.blue,
                          labelStyle: AppTextStyle.titleSmall(context).copyWith(
                            color: _selectedDay == index
                                ? AppColor.whiteColor(context)
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // جدول الحصص
                Expanded(
                  child: ListView.builder(
                    itemCount: schedule.where((e) => e.day == _daysEn[_selectedDay]).length,
                    itemBuilder: (context, index) {
                      final items = schedule.where((e) => e.day == _daysEn[_selectedDay]).toList()
                        ..sort((a, b) => a.period.compareTo(b.period));
                      final period = items[index];
                      return _buildPeriodCard(period);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPeriodCard(ScheduleModel period) {
    final isBreak = period.subjectName == 'فسحة' || period.subjectName == 'Break';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: isBreak ? Colors.orange.shade50 : AppColor.whiteColor(context),
      child: ListTile(
        leading: Container(
          width: 50.w,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: isBreak ? Colors.orange.shade100 : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isBreak ? Icons.coffee : Icons.school,
                size: 20.w,
                color: isBreak ? Colors.orange : Colors.blue,
              ),
            ],
          ),
        ),
        title: Text(
          period.subjectName,
          style: AppTextStyle.titleMedium(context).copyWith(
            fontWeight: FontWeight.bold,
            color: isBreak ? Colors.orange : Colors.grey.shade800,
          ),
        ),
        subtitle: Text(
          period.teacherName,
          style: AppTextStyle.bodySmall(context).copyWith(color: Colors.grey.shade600),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${period.startTime} - ${period.endTime}',
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
            ),
            if (!isBreak)
              Text(
                'period ${period.period}',
                style: AppTextStyle.bodySmall(
                  context,
                ).copyWith(fontSize: 10.sp, color: Colors.grey.shade500),
              ),
          ],
        ),
      ),
    );
  }
}
