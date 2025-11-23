import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusStopItem extends StatelessWidget {
  const BusStopItem({
    super.key,
    required this.name,
    required this.time,
    required this.status,
    required this.isCompleted,
    this.isNext = false,
  });

  final String name;
  final String time;
  final String status;
  final bool isCompleted;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: const Color(0xFFE5E7EB), width: 1)),
      ),
      child: Row(
        children: [
          // Indicator Circle
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? const Color(0xFF10B981) : Colors.transparent,
              border: isNext ? Border.all(color: const Color(0xFF2E5BFF), width: 2) : null,
              gradient: isNext
                  ? const LinearGradient(
                      colors: [Color(0xFF2E5BFF), Color(0xFF7C3AED)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
            ),
            child: Center(
              child: isCompleted
                  ? Icon(Icons.check, color: Colors.white, size: 14.w)
                  : isNext
                  ? Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF2E5BFF),
                      ),
                    )
                  : null,
            ),
          ),
          SizedBox(width: 12.w),

          // Station Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  time,
                  style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),

          // Status Tag
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isCompleted
                  ? const Color(0xFFD1FAE5)
                  : isNext
                  ? const Color(0xFFEFF6FF)
                  : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: isCompleted
                    ? const Color(0xFF065F46)
                    : isNext
                    ? const Color(0xFF2E5BFF)
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
