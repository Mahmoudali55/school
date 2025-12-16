import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/bus/data/model/admin_bus_model.dart';

class BusesSelectorWidget extends StatelessWidget {
  final List<BusModel> buses;
  final BusModel selectedBus;
  final ValueChanged<BusModel> onSelect;

  const BusesSelectorWidget({
    super.key,
    required this.buses,
    required this.selectedBus,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Wrap(
        spacing: 8.w,
        children: buses.map((bus) {
          final isSelected = bus.busNumber == selectedBus.busNumber;
          return ChoiceChip(
            selected: isSelected,
            label: Text(bus.busNumber),
            selectedColor: bus.busColor,
            onSelected: (_) => onSelect(bus),
          );
        }).toList(),
      ),
    );
  }
}
