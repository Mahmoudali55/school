import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SafetyFeatures extends StatelessWidget {
  final Function(String) onFeatureTap;

  const SafetyFeatures({super.key, required this.onFeatureTap});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> features = [
      {'title': 'تنبيه الوصول', 'icon': Icons.notifications_active_rounded, 'color': Colors.orange},
      {'title': 'مشاركة الموقع', 'icon': Icons.share_rounded, 'color': Colors.blue},
      {'title': 'الاتصال العاجل', 'icon': Icons.emergency_rounded, 'color': Colors.red},
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
