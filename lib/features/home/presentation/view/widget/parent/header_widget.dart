import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/home_models.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/dropdown_select_student_widget.dart';
import 'package:my_template/features/home/presentation/view/widget/parent/welcome_parent_widget.dart';

class HeaderWidget extends StatelessWidget {
  final String parentName;
  final List<StudentMiniInfo>? students;
  final StudentMiniInfo? selectedStudent;

  const HeaderWidget({super.key, required this.parentName, this.students, this.selectedStudent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WelcomeParentWidget(parentName: parentName),
        Gap(16.h),
        Text(
          AppLocalKay.select_student.tr(),
          style: AppTextStyle.bodyMedium(
            context,
            color: const Color(0xFF1F2937),
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        Gap(8.h),

        DropdownSelectStudentWidget(students: students, selectedStudent: selectedStudent),
      ],
    );
  }
}
