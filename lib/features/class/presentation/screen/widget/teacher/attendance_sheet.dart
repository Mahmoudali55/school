import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/class/data/model/teacher_classes_models.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceSheet extends StatefulWidget {
  final ClassInfo classInfo;

  const AttendanceSheet({super.key, required this.classInfo});

  @override
  State<AttendanceSheet> createState() => _AttendanceSheetState();
}

class _AttendanceSheetState extends State<AttendanceSheet> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchAttendance(_selectedDay!);
  }

  void _fetchAttendance(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    context.read<ClassCubit>().classAbsent(
      classCode: int.tryParse(widget.classInfo.id) ?? 0,
      HWDATE: dateStr,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: AppColor.scaffoldColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        children: [
          Gap(12.h),
          Container(
            width: 50.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: AppColor.grey300Color(context).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          Gap(24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalKay.absent_from_class.tr(),
                        style: AppTextStyle.bodySmall(context).copyWith(
                          color: AppColor.primaryColor(context),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        widget.classInfo.className,
                        style: AppTextStyle.headlineSmall(
                          context,
                        ).copyWith(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor(context).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: AppColor.primaryColor(context),
                    size: 24.sp,
                  ),
                ),
              ],
            ),
          ),
          Gap(24.h),
          _buildCalendar(),
          Gap(16.h),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.surfaceColor(context),
                borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.blackColor(context).withValues(alpha: 0.03),
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: BlocBuilder<ClassCubit, ClassState>(
                builder: (context, state) {
                  if (state.classAbsentStatus.isLoading) {
                    return _buildLoadingState();
                  } else if (state.classAbsentStatus.isFailure) {
                    return _buildErrorState(state.classAbsentStatus.error);
                  } else if (state.classAbsentStatus.isSuccess) {
                    final list = state.classAbsentStatus.data ?? [];
                    if (list.isEmpty) {
                      return _buildEmptyState();
                    }
                    return _buildAttendanceList(list);
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColor.surfaceColor(context),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: CalendarFormat.week,
        availableGestures: AvailableGestures.horizontalSwipe,
        headerVisible: false,
        daysOfWeekHeight: 30.h,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            _fetchAttendance(selectedDay);
          }
        },
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: TextStyle(
            color: AppColor.errorColor(context).withValues(alpha: 0.6),
            fontSize: 14.sp,
          ),
          defaultTextStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          selectedDecoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.primaryColor(context),
                AppColor.primaryColor(context).withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryColor(context).withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          todayDecoration: BoxDecoration(
            color: AppColor.primaryColor(context).withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: AppColor.primaryColor(context), width: 1),
          ),
          todayTextStyle: TextStyle(
            color: AppColor.primaryColor(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: AppColor.greyColor(context).withValues(alpha: 0.8),
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
          weekendStyle: TextStyle(
            color: AppColor.errorColor(context).withValues(alpha: 0.5),
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceList(List list) {
    return ListView.builder(
      padding: EdgeInsets.all(24.r),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final bool isAbsent = item.absentType == 0;

        return FadeInUp(
          duration: Duration(milliseconds: 400 + (index * 100)),
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: AppColor.scaffoldColor(context),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppColor.blackColor(context).withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    width: 6.w,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isAbsent
                              ? [
                                  AppColor.errorColor(context),
                                  AppColor.errorColor(context).withValues(alpha: 0.6),
                                ]
                              : [
                                  AppColor.infoColor(context),
                                  AppColor.infoColor(context).withValues(alpha: 0.6),
                                ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                            color:
                                (isAbsent
                                        ? AppColor.errorColor(context)
                                        : AppColor.infoColor(context))
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Icon(
                            isAbsent ? Icons.person_off_rounded : Icons.beach_access_rounded,
                            color: isAbsent
                                ? AppColor.errorColor(context)
                                : AppColor.infoColor(context),
                            size: 24.sp,
                          ),
                        ),
                        Gap(16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.studentFullName,
                                style: AppTextStyle.bodyMedium(
                                  context,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                              Gap(4.h),
                              Text(
                                item.notes.isEmpty
                                    ? (isAbsent
                                          ? AppLocalKay.unexcused_absence.tr()
                                          : AppLocalKay.excused_absence.tr())
                                    : item.notes,
                                style: AppTextStyle.bodySmall(
                                  context,
                                ).copyWith(color: AppColor.greyColor(context)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color:
                                (isAbsent
                                        ? AppColor.errorColor(context)
                                        : AppColor.infoColor(context))
                                    .withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color:
                                  (isAbsent
                                          ? AppColor.errorColor(context)
                                          : AppColor.infoColor(context))
                                      .withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            isAbsent ? AppLocalKay.absent.tr() : AppLocalKay.excused.tr(),
                            style: TextStyle(
                              color: isAbsent
                                  ? AppColor.errorColor(context)
                                  : AppColor.infoColor(context),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return FadeIn(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(30.r),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_outline_rounded,
                size: 80.sp,
                color: Colors.green.withValues(alpha: 0.5),
              ),
            ),
            Gap(24.h),
            Text(
              AppLocalKay.no_absence_today.tr(),
              style: AppTextStyle.titleMedium(
                context,
              ).copyWith(fontWeight: FontWeight.bold, color: AppColor.greyColor(context)),
            ),
            Gap(8.h),
            Text(
              AppLocalKay.happy_day.tr(),
              style: AppTextStyle.bodySmall(
                context,
              ).copyWith(color: AppColor.greyColor(context).withValues(alpha: 0.6)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColor.primaryColor(context), strokeWidth: 3),
          Gap(16.h),
          Text(
            AppLocalKay.loading_data.tr(),
            style: AppTextStyle.bodySmall(context).copyWith(color: AppColor.greyColor(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String? error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 60.sp, color: AppColor.errorColor(context)),
            Gap(16.h),
            Text(error ?? "", textAlign: TextAlign.center, style: AppTextStyle.bodyMedium(context)),
            Gap(24.h),
            ElevatedButton(
              onPressed: () => _fetchAttendance(_selectedDay!),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor(context),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
              ),
              child: Text(AppLocalKay.retry.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
