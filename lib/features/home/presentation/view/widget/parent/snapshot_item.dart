import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SnapshotItem extends StatelessWidget {
  final String title;
  final Widget child;

  const SnapshotItem({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6B7280),
          ),
        ),
        SizedBox(height: 8.h),
        child,
      ],
    );
  }
}
