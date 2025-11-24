import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ControlButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const ControlButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18.w),
            SizedBox(height: 8.h),
            Text(
              text,
              style: TextStyle(fontSize: 10.sp, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
