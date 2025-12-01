import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';

class ClassSelectorWidget extends StatelessWidget {
  final ClassInfo? selectedClass;
  final List<ClassInfo> classes;
  final Function(ClassInfo?) onChanged;

  const ClassSelectorWidget({
    super.key,
    required this.selectedClass,
    required this.classes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.accentColor(context).withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ClassInfo?>(
          value: selectedClass,
          icon: Icon(Icons.arrow_drop_down_rounded, color: AppColor.accentColor(context)),
          isExpanded: true,
          style: AppTextStyle.titleMedium(
            context,
          ).copyWith(color: const Color(0xFF1F2937), fontWeight: FontWeight.w600),
          onChanged: onChanged,
          items: [
            DropdownMenuItem<ClassInfo?>(value: null, child: Text("اختر صف")),
            ...classes.map<DropdownMenuItem<ClassInfo?>>((ClassInfo value) {
              return DropdownMenuItem<ClassInfo?>(
                value: value,
                child: Row(
                  children: [
                    Icon(Icons.class_rounded, size: 16.w, color: AppColor.accentColor(context)),
                    SizedBox(width: 6.w),
                    Text(value.fullName),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
