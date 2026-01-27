import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class StudentGradesWidget extends StatelessWidget {
  const StudentGradesWidget({
    super.key,
    required int? studentCode,
    required PageController pageController,
  }) : _studentCode = studentCode,
       _pageController = pageController;

  final int? _studentCode;
  final PageController _pageController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final grades = state.studentCourseDegreeStatus.data ?? [];

        if (_studentCode == null || state.studentCourseDegreeStatus.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (grades.isEmpty) {
          return Center(child: Text("لا توجد درجات", style: AppTextStyle.bodyMedium(context)));
        }

        return SizedBox(
          height: 140.h,
          child: PageView.builder(
            controller: _pageController,
            physics: grades.length <= 1
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            itemCount: grades.length,
            itemBuilder: (context, index) {
              final item = grades[index];

              // --- نسبة الطالب + الحالة ---
              final percentage = (item.studentDegree / item.courseDegree) * 100;
              String status;
              if (percentage >= 90) {
                status = "ممتاز";
              } else if (percentage >= 75) {
                status = "جيد جدًا";
              } else if (percentage >= 60) {
                status = "جيد";
              } else {
                status = "ضعيف";
              }

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColor.primaryColor(context), const Color(0xFF1E40AF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primaryColor(context).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.courseName,
                      style: AppTextStyle.bodyMedium(
                        context,
                      ).copyWith(color: AppColor.whiteColor(context), fontWeight: FontWeight.bold),
                    ),
                    Gap(8.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${item.studentDegree}",
                          style: AppTextStyle.headlineLarge(context).copyWith(
                            color: AppColor.whiteColor(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 28.sp,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h, left: 4.w),
                          child: Text(
                            "/${item.courseDegree}",
                            style: AppTextStyle.bodyLarge(
                              context,
                            ).copyWith(color: AppColor.whiteColor(context)),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColor.whiteColor(context).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            status,
                            style: AppTextStyle.bodySmall(context).copyWith(
                              color: AppColor.whiteColor(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(6.h),
                    LinearProgressIndicator(
                      value: item.studentDegree / item.courseDegree,
                      backgroundColor: AppColor.whiteColor(context).withOpacity(0.3),
                      color: Colors.yellowAccent,
                      minHeight: 6.h,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
