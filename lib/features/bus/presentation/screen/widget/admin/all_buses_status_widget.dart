import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllBusesStatusWidget extends StatelessWidget {
  final List<Map<String, dynamic>> allBusesData;

  const AllBusesStatusWidget({super.key, required this.allBusesData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "حالة جميع الحافلات",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allBusesData.length,
            separatorBuilder: (_, __) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              final bus = allBusesData[index];
              return Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(bus['busNumber'], style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      bus['status'],
                      style: TextStyle(
                        color: bus['status'] == "Active" ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
