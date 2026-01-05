import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/data/model/bus_tracking_models.dart';

class ChildrenSelector extends StatelessWidget {
  final List<String> children;
  final String selectedChild;
  final List<BusClass> childrenBusData;
  final ValueChanged<String> onSelected;

  const ChildrenSelector({
    super.key,
    required this.children,
    required this.selectedChild,
    required this.childrenBusData,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.family_restroom_rounded,
                color: AppColor.primaryColor(context),
                size: 20.w,
              ),
              SizedBox(width: 8.w),
              Text(
                AppLocalKay.select_student.tr(),
                style: AppTextStyle.titleMedium(
                  context,
                ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: children.map((child) => _buildChildChip(context, child)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChildChip(BuildContext context, String childName) {
    final isSelected = selectedChild == childName;
    final childData = childrenBusData.firstWhere((data) => data.childName == childName);

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            childData.status == 'في الطريق' ? Icons.directions_bus_rounded : Icons.person_rounded,
            size: 16.w,
            color: isSelected ? AppColor.whiteColor(context) : childData.busColor,
          ),
          SizedBox(width: 6.w),
          Text(childName),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          onSelected(childName);
        }
      },
      backgroundColor: AppColor.whiteColor(context),
      selectedColor: childData.busColor,
      labelStyle: AppTextStyle.bodyMedium(context).copyWith(
        color: isSelected ? AppColor.whiteColor(context) : const Color(0xFF6B7280),
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? childData.busColor : const Color(0xFFE5E7EB)),
      ),
    );
  }
}
