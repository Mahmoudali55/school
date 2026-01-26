import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/routes/routes_name.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/core/utils/navigator_methods.dart';
import 'package:my_template/features/home/data/models/home_models.dart';

import '../../../cubit/home_cubit.dart';

class HeaderWidget extends StatelessWidget {
  final String parentName;
  final List<StudentMiniInfo> students;
  final StudentMiniInfo selectedStudent;

  const HeaderWidget({
    super.key,
    required this.parentName,
    required this.students,
    required this.selectedStudent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalKay.welcome.tr(),
                  style: AppTextStyle.bodyLarge(context, color: const Color(0xFF6B7280)),
                ),
                Text(
                  parentName,
                  style: AppTextStyle.headlineSmall(
                    context,
                    color: const Color(0xFF1F2937),
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                NavigatorMethods.pushNamed(
                  context,
                  RoutesName.parentProfileScreen,
                  arguments: int.tryParse(HiveMethods.getUserCode()) ?? 0,
                );
              },
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.1 * 255).round()),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.family_restroom, color: const Color(0xFF2E5BFF), size: 28.w),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          AppLocalKay.select_student.tr(),
          style: AppTextStyle.bodyMedium(
            context,
            color: const Color(0xFF1F2937),
          ).copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),

        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonFormField<StudentMiniInfo>(
            value: selectedStudent,
            decoration: InputDecoration(
              labelStyle: AppTextStyle.bodyMedium(context, color: const Color(0xFF6B7280)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF2E5BFF)),
            ),
            items: students
                .map((student) => DropdownMenuItem(value: student, child: Text(student.name)))
                .toList(),
            onChanged: (student) {
              if (student != null) {
                context.read<HomeCubit>().changeSelectedStudent(student);
              }
            },
          ),
        ),
      ],
    );
  }
}
