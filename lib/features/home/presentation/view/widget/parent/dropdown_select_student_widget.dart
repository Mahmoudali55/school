import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/home/data/models/home_models.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';

class DropdownSelectStudentWidget extends StatelessWidget {
  const DropdownSelectStudentWidget({
    super.key,
    required this.students,
    required this.selectedStudent,
  });

  final List<StudentMiniInfo>? students;
  final StudentMiniInfo? selectedStudent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor(context).withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          if (students == null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColor.whiteColor(context),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.person_outline, color: AppColor.primaryColor(context)),
                  Gap(12.w),
                  Text(
                    AppLocalKay.loading.tr(),
                    style: AppTextStyle.bodyMedium(context, color: AppColor.grey300Color(context)),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ),
            )
          else
            DropdownButtonFormField<StudentMiniInfo>(
              initialValue: selectedStudent,
              decoration: InputDecoration(
                labelStyle: AppTextStyle.bodyMedium(context, color: AppColor.grey300Color(context)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColor.whiteColor(context),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                prefixIcon: Icon(Icons.person_outline, color: AppColor.primaryColor(context)),
              ),
              items: students!
                  .map((student) => DropdownMenuItem(value: student, child: Text(student.name)))
                  .toList(),
              onChanged: (student) {
                if (student != null) {
                  context.read<HomeCubit>().changeSelectedStudent(student);
                }
              },
            ),
        ],
      ),
    );
  }
}
