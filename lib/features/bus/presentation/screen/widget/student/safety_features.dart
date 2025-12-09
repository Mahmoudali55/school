import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class SafetyFeatures extends StatelessWidget {
  final Function(String) onFeatureTap;

  const SafetyFeatures({super.key, required this.onFeatureTap});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> features = [
      {
        'title': AppLocalKay.arrival_alert.tr(),
        'icon': Icons.notifications_active_rounded,
        'color': Colors.orange,
      },
      {'title': AppLocalKay.share_location.tr(), 'icon': Icons.share_rounded, 'color': Colors.blue},
      {
        'title': AppLocalKay.emergency_management.tr(),
        'icon': Icons.emergency_rounded,
        'color': Colors.red,
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: features.map((feature) {
          return GestureDetector(
            onTap: () => onFeatureTap(feature['title']),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: feature['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(feature['icon'], color: feature['color'], size: 28.w),
                ),
                SizedBox(height: 8.h),
                Text(feature['title'], style: TextStyle(fontSize: 12.sp)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
