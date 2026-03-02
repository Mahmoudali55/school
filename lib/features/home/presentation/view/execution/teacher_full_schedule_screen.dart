import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/custom_widgets/custom_loading/custom_loading.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/teacher_time_table_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class TeacherFullScheduleScreen extends StatefulWidget {
  const TeacherFullScheduleScreen({super.key});

  @override
  State<TeacherFullScheduleScreen> createState() => _TeacherFullScheduleScreenState();
}

class _TeacherFullScheduleScreenState extends State<TeacherFullScheduleScreen> {
  int _selectedDayIndex = DateTime.now().weekday % 7; // Sunday=0, Monday=1, ..., Saturday=6

  final List<String> _days = [
    "الأحد",
    "الاثنين",
    "الثلاثاء",
    "الأربعاء",
    "الخميس",
    "الجمعة",
    "السبت",
  ];

  final Map<String, String> _englishToArabicDays = {
    'Sunday': 'الأحد',
    'Monday': 'الاثنين',
    'Tuesday': 'الثلاثاء',
    'Wednesday': 'الأربعاء',
    'Thursday': 'الخميس',
    'Friday': 'الجمعة',
    'Saturday': 'السبت',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final code = int.tryParse(HiveMethods.getUserCode()) ?? 0;
        context.read<HomeCubit>().teacherTimeTable(Code: code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedDayIndex < 0) _selectedDayIndex = 0;

    return Scaffold(
      backgroundColor: AppColor.whiteColor(context),
      appBar: CustomAppBar(
        context,
        title: Text(
          AppLocalKay.full_schedule_teacher.tr(),
          style: AppTextStyle.titleLarge(
            context,
          ).copyWith(fontWeight: FontWeight.bold, color: AppColor.blackColor(context)),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColor.blackColor(context)),
        ),
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final scheduleStatus = state.teacherTimeTableStatus;

          return Column(
            children: [
              _buildDaySelector(),
              if (scheduleStatus?.isLoading ?? false)
                const Expanded(child: Center(child: CustomLoading()))
              else if (scheduleStatus?.isFailure ?? false)
                Expanded(child: Center(child: Text(scheduleStatus?.error ?? "")))
              else if (scheduleStatus?.isSuccess ?? false)
                Expanded(child: _buildTimeline(scheduleStatus!.data!))
              else
                const Expanded(child: SizedBox.shrink()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDaySelector() {
    return Container(
      height: 90.h,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: _days.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedDayIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedDayIndex = index),
            child: FadeInRight(
              delay: Duration(milliseconds: index * 100),
              child: Container(
                width: 70.w,
                margin: EdgeInsets.only(right: 12.w),
                decoration: BoxDecoration(
                  color: isSelected ? AppColor.primaryColor(context) : AppColor.whiteColor(context),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColor.primaryColor(context).withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _days[index].substring(0, 1),
                      style: AppTextStyle.bodyLarge(context).copyWith(
                        color: isSelected
                            ? AppColor.whiteColor(context)
                            : AppColor.greyColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _days[index],
                      style: AppTextStyle.bodySmall(context).copyWith(
                        color: isSelected
                            ? AppColor.whiteColor(context)
                            : AppColor.greyColor(context),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeline(List<TeacherTimeTableModel> allData) {
    final filteredData = allData.where((item) {
      final arabicDay = _englishToArabicDays[item.day] ?? item.day;
      return arabicDay == _days[_selectedDayIndex];
    }).toList();

    // Sort by start time if necessary
    filteredData.sort((a, b) => a.startTime.compareTo(b.startTime));

    if (filteredData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, size: 50.sp, color: AppColor.greyColor(context)),
            Gap(10.h),
            Text(
              AppLocalKay.no_classes_today.tr(),
              style: AppTextStyle.bodyLarge(context).copyWith(color: AppColor.greyColor(context)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final item = filteredData[index];
        final now = DateTime.now();
        final currentDayArabic = _days[now.weekday % 7];

        bool isCurrent = false;
        final itemDayArabic = _englishToArabicDays[item.day] ?? item.day;

        if (itemDayArabic == currentDayArabic) {
          try {
            // Parse HH:mm:ss if present, or just HH:mm
            final timeFormat = DateFormat('HH:mm');
            final startStr = item.startTime.substring(0, 5);
            final endStr = item.endTime.substring(0, 5);

            final start = timeFormat.parse(startStr);
            final end = timeFormat.parse(endStr);
            final current = timeFormat.parse(DateFormat('HH:mm').format(now));

            isCurrent = current.isAfter(start) && current.isBefore(end);
          } catch (e) {
            isCurrent = false;
          }
        }

        return _buildTimelineItem(
          item.startTime,
          item.subjectName,
          "${AppLocalKay.class_name.tr()} ${item.classCode}",
          "${AppLocalKay.room.tr()} ${item.room}",
          _getRandomColor(item.subjectCode),
          isCurrent: isCurrent,
          isBreak: item.subjectName == "استراحة" || item.subjectName == "Break",
        );
      },
    );
  }

  Color _getRandomColor(int seed) {
    final colors = [
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFF3B82F6),
      const Color(0xFF6366F1),
    ];
    return colors[seed % colors.length];
  }

  Widget _buildTimelineItem(
    String time,
    String subject,
    String classroom,
    String room,
    Color color, {
    bool isCurrent = false,
    bool isBreak = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Text(
                time.substring(0, 5),
                style: AppTextStyle.bodySmall(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: isCurrent ? color : AppColor.greyColor(context),
                ),
              ),
              Gap(8.h),
              Expanded(
                child: Container(
                  width: 2.w,
                  color: isCurrent ? color : AppColor.greyColor(context).withValues(alpha: (0.2)),
                ),
              ),
            ],
          ),
          Gap(16.w),
          Expanded(
            child: FadeInLeft(
              child: Container(
                margin: EdgeInsets.only(bottom: 24.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor(context),
                  borderRadius: BorderRadius.circular(20.r),
                  border: isCurrent ? Border.all(color: color, width: 2) : null,
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.blackColor(context).withValues(alpha: (0.05)),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    Gap(16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject,
                            style: AppTextStyle.bodyLarge(
                              context,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (!isBreak) ...[
                            Gap(4.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.class_rounded,
                                  size: 14.w,
                                  color: AppColor.greyColor(context),
                                ),
                                Gap(4.w),
                                Flexible(
                                  child: Text(
                                    classroom,
                                    style: AppTextStyle.bodySmall(
                                      context,
                                    ).copyWith(color: AppColor.greyColor(context)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Gap(12.w),
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 14.w,
                                  color: AppColor.greyColor(context),
                                ),
                                Gap(4.w),
                                Flexible(
                                  child: Text(
                                    room,
                                    style: AppTextStyle.bodySmall(
                                      context,
                                    ).copyWith(color: AppColor.greyColor(context)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isCurrent)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: (0.1)),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          AppLocalKay.now.tr(),
                          style: AppTextStyle.bodySmall(
                            context,
                          ).copyWith(color: color, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
