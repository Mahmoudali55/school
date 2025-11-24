import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmergencyButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const EmergencyButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(Icons.warning, color: Colors.white),
          label: Text(
            "زر الطوارئ",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ),
    );
  }
}
