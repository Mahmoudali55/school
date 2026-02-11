import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';

class ParentCalendarControlBar extends StatelessWidget {
  final String? selectedStudent;
  final List<String> students;
  final List<ClassInfo> classes;
  final ClassInfo? selectedClass;
  final int currentView;
  final Function(String) onStudentChanged;
  final Function(ClassInfo) onClassChanged;
  final Function(int) onViewSelected;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const ParentCalendarControlBar({
    super.key,
    this.selectedStudent,
    required this.students,
    required this.classes,
    this.selectedClass,
    required this.currentView,
    required this.onStudentChanged,
    required this.onClassChanged,
    required this.onViewSelected,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: AppColor.whiteColor(context),
      child: Column(
        children: [
          // اختيار الطالب
          _buildStudentSelector(context),
          if (classes.isNotEmpty) ...[SizedBox(height: 8.h), _buildClassSelector(context)],
          SizedBox(height: 12.h),
          // شريط العرض والتنقل
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildViewButton(context, AppLocalKay.backupFrequencyMonthly.tr(), 0),
                      _buildViewButton(context, AppLocalKay.backupFrequencyWeekly.tr(), 1),
                      _buildViewButton(context, AppLocalKay.backupFrequencyDaily.tr(), 2),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_right_rounded, size: 20.w),
                      onPressed: onPrevious,
                    ),
                    Container(
                      width: 1.w,
                      height: 20.h,
                      color: const Color(0xFF2196F3).withOpacity(0.3),
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_left_rounded, size: 20.w),
                      onPressed: onNext,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentSelector(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: (selectedStudent != null && students.contains(selectedStudent))
              ? selectedStudent
              : (students.isNotEmpty ? students.first : null),
          hint: Text(AppLocalKay.loading.tr(), style: AppTextStyle.bodySmall(context)),
          icon: const Icon(Icons.arrow_drop_down_rounded, color: Color(0xFF2196F3)),
          style: AppTextStyle.bodyMedium(
            context,
          ).copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF1F2937)),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onStudentChanged(newValue);
            }
          },
          items: students.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(Icons.person_outline_rounded, size: 16.w, color: const Color(0xFF2196F3)),
                  SizedBox(width: 6.w),
                  Text(value),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildViewButton(BuildContext context, String text, int index) {
    bool isSelected = currentView == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onViewSelected(index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2196F3) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              text,
              style: AppTextStyle.bodySmall(context).copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColor.whiteColor(context) : const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClassSelector(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF22C55E).withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ClassInfo>(
          value: selectedClass,
          hint: Text(AppLocalKay.classes.tr(), style: AppTextStyle.bodySmall(context)),
          icon: const Icon(Icons.arrow_drop_down_rounded, color: Color(0xFF22C55E)),
          isExpanded: true,
          style: AppTextStyle.bodyMedium(
            context,
          ).copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF1F2937)),
          onChanged: (ClassInfo? newValue) {
            if (newValue != null) {
              onClassChanged(newValue);
            }
          },
          items: classes.map<DropdownMenuItem<ClassInfo>>((ClassInfo value) {
            return DropdownMenuItem<ClassInfo>(
              value: value,
              child: Row(
                children: [
                  Icon(Icons.class_outlined, size: 16.w, color: const Color(0xFF22C55E)),
                  SizedBox(width: 6.w),
                  Text(value.name),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
