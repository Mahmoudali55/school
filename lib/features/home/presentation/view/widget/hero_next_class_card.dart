import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeroNextClassCard extends StatelessWidget {
  const HeroNextClassCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule, color: Colors.white, size: 26.w),
              SizedBox(width: 8.w),
              Text(
                "الحصة القادمة",
                style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          Text(
            "الرياضيات",
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white),
          ),

          SizedBox(height: 8.h),

          Row(
            children: [
              Icon(Icons.access_time, color: Colors.white, size: 16.w),
              SizedBox(width: 6.w),
              Text(
                "١٠:٠٠ - ١٠:٤٥ صباحاً",
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          Row(
            children: [
              Icon(Icons.person, color: Colors.white, size: 16.w),
              SizedBox(width: 6.w),
              Text(
                "أ. أحمد محمد",
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.video_call, size: 20.w),
            label: Text(
              "انضم إلى الحصة الافتراضية",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Color(0xFF2196F3),
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}
