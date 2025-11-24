import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusesSelectorWidget extends StatelessWidget {
  final List<String> buses;
  final String selectedBus;
  final List<Map<String, dynamic>> allBusesData;
  final void Function(String busNumber, Map<String, dynamic> busData) onBusSelected;

  const BusesSelectorWidget({
    super.key,
    required this.buses,
    required this.selectedBus,
    required this.allBusesData,
    required this.onBusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.directions_bus_rounded, color: Color(0xFF9C27B0), size: 20.w),
              SizedBox(width: 8.w),
              Text(
                "اختر الحافلة للمتابعة",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: buses.map((bus) {
              final isSelected = selectedBus == bus;
              final busData = allBusesData.firstWhere((data) => data['busNumber'] == bus);
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.directions_bus_rounded,
                      size: 16.w,
                      color: isSelected ? Colors.white : busData['busColor'],
                    ),
                    SizedBox(width: 6.w),
                    Text(bus),
                  ],
                ),
                selected: isSelected,
                onSelected: (_) => onBusSelected(bus, busData),
                backgroundColor: Colors.white,
                selectedColor: busData['busColor'],
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  color: isSelected ? Colors.white : Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: isSelected ? busData['busColor'] : Color(0xFFE5E7EB)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
