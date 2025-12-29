import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class CalendarControlBar extends StatelessWidget {
  final String selectedFilter;
  final List<String> filters;
  final int currentView;
  final Function(String) onFilterSelected;
  final Function(int) onViewSelected;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const CalendarControlBar({
    super.key,
    required this.selectedFilter,
    required this.filters,
    required this.currentView,
    required this.onFilterSelected,
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
          // تصفية الأحداث
          _buildFilterSelector(context),
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
                      _buildViewButton(
                        context,
                        AppLocalKay.backupFrequencyDaily.tr(),
                        0,
                      ),
                      _buildViewButton(
                        context,
                        AppLocalKay.backupFrequencyWeekly.tr(),
                        1,
                      ),
                      _buildViewButton(
                        context,
                        AppLocalKay.backupFrequencyMonthly.tr(),
                        2,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0).withOpacity(0.1),
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
                      color: const Color(0xFF9C27B0).withOpacity(0.3),
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

  Widget _buildFilterSelector(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters
            .map(
              (filter) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: FilterChip(
                  label: Text(
                    filter,
                    style: AppTextStyle.bodySmall(context).copyWith(
                      color: selectedFilter == filter
                          ? AppColor.whiteColor(context)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                  selected: selectedFilter == filter,
                  onSelected: (bool selected) {
                    onFilterSelected(
                      selected ? filter : AppLocalKay.filter_all.tr(),
                    );
                  },
                  backgroundColor: AppColor.whiteColor(context),
                  selectedColor: const Color(0xFF9C27B0),
                  checkmarkColor: AppColor.whiteColor(context),
                  side: BorderSide(
                    color: selectedFilter == filter
                        ? const Color(0xFF9C27B0)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
              ),
            )
            .toList(),
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
            color: isSelected ? const Color(0xFF9C27B0) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              text,
              style: AppTextStyle.bodySmall(context).copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColor.whiteColor(context)
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
