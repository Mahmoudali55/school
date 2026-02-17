import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/class/presentation/cubit/class_cubit.dart';
import 'package:my_template/features/class/presentation/cubit/class_state.dart';

class StudentsBottomSheet extends StatelessWidget {
  final String className;
  final int classCode;

  const StudentsBottomSheet({super.key, required this.className, required this.classCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.8.sh,
      decoration: BoxDecoration(
        color: AppColor.scaffoldColor(context),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Gap(12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColor.grey200Color(context),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Gap(16.h),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "قائمة الطلاب",
                        style: AppTextStyle.titleMedium(
                          context,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        className,
                        style: AppTextStyle.bodySmall(context).copyWith(
                          color: AppColor.primaryColor(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close_rounded, color: AppColor.greyColor(context)),
                ),
              ],
            ),
          ),
          Gap(16.h),
          const Divider(height: 1),
          // Content
          Expanded(
            child: BlocBuilder<ClassCubit, ClassState>(
              builder: (context, state) {
                if (state.studentClassesStatus.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.studentClassesStatus.isFailure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: AppColor.errorColor(context),
                          size: 48.sp,
                        ),
                        Gap(16.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Text(
                            state.studentClassesStatus.error ?? 'Error loading students',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.bodyMedium(context),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final students = state.studentClassesStatus.data?.students ?? [];

                if (students.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline_rounded,
                          color: AppColor.greyColor(context),
                          size: 64.sp,
                        ),
                        Gap(16.h),
                        Text(
                          "لا يوجد طلاب في هذا الفصل",
                          style: AppTextStyle.titleSmall(
                            context,
                          ).copyWith(color: AppColor.greyColor(context)),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.all(20.w),
                  itemCount: students.length,
                  separatorBuilder: (context, index) => Gap(12.h),
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor(context),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColor.borderColor(context)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor(context).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                student.studentName.characters.take(1).toString(),
                                style: TextStyle(
                                  color: AppColor.primaryColor(context),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ),
                          Gap(16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.studentName,
                                  style: AppTextStyle.bodyMedium(
                                    context,
                                  ).copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "كود الطالب: ${student.studentCode}",
                                  style: AppTextStyle.bodySmall(
                                    context,
                                  ).copyWith(color: AppColor.greyColor(context), fontSize: 10.sp),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded, color: AppColor.grey200Color(context)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
