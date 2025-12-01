import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class CalenderClassSelectorWidget extends StatefulWidget {
  const CalenderClassSelectorWidget({super.key});

  @override
  State<CalenderClassSelectorWidget> createState() => _CalenderClassSelectorWidgetState();
}

class _CalenderClassSelectorWidgetState extends State<CalenderClassSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    String _selectedClass = "الصف العاشر - علمي";
    List<String> _classes = ["الصف العاشر - علمي", "الصف التاسع - أدبي", "الصف الحادي عشر - علمي"];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.accentColor(context).withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedClass,
          icon: Icon(Icons.arrow_drop_down_rounded, color: AppColor.accentColor(context)),
          style: AppTextStyle.titleMedium(
            context,
          ).copyWith(color: const Color(0xFF1F2937), fontWeight: FontWeight.w600),
          onChanged: (String? newValue) {
            setState(() {
              _selectedClass = newValue!;
            });
          },
          items: _classes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(Icons.class_rounded, size: 16.w, color: AppColor.accentColor(context)),
                  SizedBox(width: 6.w),
                  Text(value),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
