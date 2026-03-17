import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_cubit.dart';
import 'package:my_template/features/calendar/presentation/cubit/calendar_state.dart';
import 'package:my_template/features/home/data/models/teacher_level_model.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class LevelSelectorWidget extends StatelessWidget {
  const LevelSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (calendarContext, calendarState) {
        return BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.teacherLevelStatus.isLoading) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            if (!state.teacherLevelStatus.isSuccess) {
              return const SizedBox.shrink();
            }

            final levels = state.teacherLevelStatus.data as List<TeacherLevelModel>;
            if (levels.isEmpty) return const SizedBox.shrink();

            final selectedLevelCode = calendarState.selectedClass?.levelCode;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalKay.level.tr(),
                    style: AppTextStyle.bodySmall(
                      context,
                    ).copyWith(color: AppColor.greyColor(context), fontWeight: FontWeight.w600),
                  ),
                  Gap(8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor(context),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColor.accentColor(context).withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.accentColor(context).withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: levels.any((l) => l.levelCode == selectedLevelCode)
                            ? selectedLevelCode
                            : null,
                        hint: Text(
                          "اختر المرحلة التعليمية",
                          style: AppTextStyle.bodyMedium(
                            context,
                          ).copyWith(color: AppColor.hintColor(context)),
                        ),
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColor.accentColor(context),
                          size: 24.w,
                        ),
                        isExpanded: true,
                        dropdownColor: AppColor.whiteColor(context),
                        borderRadius: BorderRadius.circular(12.r),
                        style: AppTextStyle.bodyMedium(context).copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColor.blackColor(context),
                        ),
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            context.read<CalendarCubit>().changeLevel(newValue);
                          }
                        },
                        items: levels.map<DropdownMenuItem<int>>((TeacherLevelModel level) {
                          return DropdownMenuItem<int>(
                            value: level.levelCode,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: AppColor.accentColor(context).withOpacity(0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.school_rounded,
                                    size: 14.w,
                                    color: AppColor.accentColor(context),
                                  ),
                                ),
                                Gap(12.w),
                                Text(level.levelName),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
