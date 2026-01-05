import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/data/model/admin_bus_model.dart';

class AdminBusesSelector extends StatelessWidget {
  final String selectedBus;
  final List<BusModel> buses;
  final Function(String) onBusSelected;

  const AdminBusesSelector({
    super.key,
    required this.selectedBus,
    required this.buses,
    required this.onBusSelected,
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
              Icon(Icons.directions_bus_rounded, color: const Color(0xFF9C27B0), size: 20.w),
              SizedBox(width: 8.w),
              Text(
                AppLocalKay.select_bus.tr(),
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
            children: buses.map((bus) => _buildBusChip(context, bus)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBusChip(BuildContext context, BusModel bus) {
    final isSelected = selectedBus == bus.busNumber;

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.directions_bus_rounded,
            size: 16.w,
            color: isSelected ? AppColor.whiteColor(context) : bus.busColor,
          ),
          SizedBox(width: 6.w),
          Text(bus.busNumber),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          onBusSelected(bus.busNumber);
        }
      },
      backgroundColor: AppColor.whiteColor(context),
      selectedColor: bus.busColor,
      labelStyle: AppTextStyle.bodyMedium(context).copyWith(
        color: isSelected ? AppColor.whiteColor(context) : const Color(0xFF6B7280),
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? bus.busColor : const Color(0xFFE5E7EB)),
      ),
    );
  }
}
