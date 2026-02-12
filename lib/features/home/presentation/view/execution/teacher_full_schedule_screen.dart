import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class TeacherFullScheduleScreen extends StatefulWidget {
  const TeacherFullScheduleScreen({super.key});

  @override
  State<TeacherFullScheduleScreen> createState() => _TeacherFullScheduleScreenState();
}

class _TeacherFullScheduleScreenState extends State<TeacherFullScheduleScreen> {
  int _selectedDayIndex = DateTime.now().weekday - 1; // 0 for Monday

  final List<String> _days = [
    "الأحد",
    "الاثنين",
    "الثلاثاء",
    "الأربعاء",
    "الخميس",
    "الجمعة",
    "السبت",
  ];

  @override
  Widget build(BuildContext context) {
    if (_selectedDayIndex < 0) _selectedDayIndex = 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          _buildDaySelector(),
          Expanded(child: _buildTimeline()),
        ],
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
                  color: isSelected ? AppColor.primaryColor(context) : Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColor.primaryColor(context).withOpacity(0.3),
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
                        color: isSelected ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _days[index],
                      style: AppTextStyle.bodySmall(
                        context,
                      ).copyWith(color: isSelected ? Colors.white : Colors.grey, fontSize: 10.sp),
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

  Widget _buildTimeline() {
    return ListView(
      padding: EdgeInsets.all(20.w),
      children: [
        _buildTimelineItem(
          "08:00 ص",
          "اللغة العربية",
          "الصف الأول - أ",
          "قاعة 102",
          AppColor.primaryColor(context),
          isCurrent: true,
        ),
        _buildTimelineItem(
          "09:00 ص",
          "التربية الإسلامية",
          "الصف الثاني - ب",
          "قاعة 205",
          const Color(0xFF10B981),
        ),
        _buildTimelineItem(
          "10:00 ص",
          "استراحة",
          "كافيتيريا المدرسة",
          "",
          const Color(0xFFF59E0B),
          isBreak: true,
        ),
        _buildTimelineItem(
          "11:00 ص",
          "اللغة العربية",
          "الصف الثالث - ج",
          "قاعة 303",
          const Color(0xFFEC4899),
        ),
        _buildTimelineItem(
          "12:00 م",
          "النشاط المدرسي",
          "الملعب الرئيسي",
          "",
          const Color(0xFF8B5CF6),
        ),
        Gap(40.h),
      ],
    );
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
                time,
                style: AppTextStyle.bodySmall(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, color: isCurrent ? color : Colors.grey),
              ),
              Gap(8.h),
              Expanded(
                child: Container(width: 2.w, color: Colors.grey.withOpacity(0.2)),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: isCurrent ? Border.all(color: color, width: 2) : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
                                Icon(Icons.class_rounded, size: 14.w, color: Colors.grey),
                                Gap(4.w),
                                Flexible(
                                  child: Text(
                                    classroom,
                                    style: AppTextStyle.bodySmall(
                                      context,
                                    ).copyWith(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Gap(12.w),
                                Icon(Icons.location_on_rounded, size: 14.w, color: Colors.grey),
                                Gap(4.w),
                                Flexible(
                                  child: Text(
                                    room,
                                    style: AppTextStyle.bodySmall(
                                      context,
                                    ).copyWith(color: Colors.grey),
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
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          "الآن",
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
