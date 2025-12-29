import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';

class ParentEmergencyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ParentEmergencyButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xFFF44336),
      foregroundColor: AppColor.whiteColor(context),
      child: Icon(Icons.emergency_rounded, size: 24.w),
    );
  }
}
