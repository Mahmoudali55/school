import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/data/model/admin_bus_model.dart';

class AdminBusesSelector extends StatefulWidget {
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
  State<AdminBusesSelector> createState() => _AdminBusesSelectorState();
}

class _AdminBusesSelectorState extends State<AdminBusesSelector> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Show only 4 buses initially, or all if _isExpanded is true
    final displayedBuses = _isExpanded ? widget.buses : widget.buses.take(4).toList();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.directions_bus_rounded, color: const Color(0xFF9C27B0), size: 20.w),
                  Gap(8.w),
                  Text(
                    AppLocalKay.select_bus.tr(),
                    style: AppTextStyle.titleMedium(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
                  ),
                ],
              ),
              if (widget.buses.length > 4)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Text(
                    _isExpanded ? "عرض أقل" : "عرض المزيد",
                    style: AppTextStyle.bodySmall(
                      context,
                    ).copyWith(color: const Color(0xFF9C27B0), fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          Gap(12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: displayedBuses.map((bus) => _buildBusChip(context, bus)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBusChip(BuildContext context, BusModel bus) {
    final isSelected = widget.selectedBus == bus.busNumber;

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.directions_bus_rounded,
            size: 16.w,
            color: isSelected ? AppColor.whiteColor(context) : bus.busColor,
          ),
          Gap(6.w),
          Text(bus.busNumber),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          widget.onBusSelected(bus.busNumber);
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
