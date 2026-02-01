import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/data/model/bus_tracking_models.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_cubit.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_state.dart';
import 'package:my_template/features/home/presentation/cubit/home_cubit.dart';
import 'package:my_template/features/home/presentation/cubit/home_state.dart';

class ClassesSelectorWidget extends StatelessWidget {
  const ClassesSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (previous, current) =>
          previous.teacherClassesStatus != current.teacherClassesStatus &&
          current.teacherClassesStatus.isSuccess,
      listener: (context, state) {
        final classes = state.teacherClassesStatus.data ?? [];
        context.read<BusCubit>().updateClassesFromTeacherHome(classes);
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, homeState) {
          return BlocBuilder<BusCubit, BusState>(
            builder: (context, busState) {
              final teacherClasses = homeState.teacherClassesStatus.data ?? [];

              return Container(
                margin: EdgeInsets.all(16.w),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor(context),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.blackColor(context).withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.class_rounded, color: AppColor.accentColor(context), size: 20.w),
                        SizedBox(width: 8.w),
                        Text(
                          AppLocalKay.classetitle.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    if (homeState.teacherClassesStatus.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (teacherClasses.isEmpty)
                      const Text("لا توجد فصول حالياً")
                    else
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: teacherClasses
                            .map(
                              (tc) => _buildTeacherClassChip(tc, context, busState.selectedClass),
                            )
                            .toList(),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTeacherClassChip(
    dynamic teacherClass, // TeacherClassModels
    BuildContext context,
    BusClass? selectedClass,
  ) {
    final isSelected = selectedClass?.id == teacherClass.classCode.toString();

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.group_rounded,
            size: 16.w,
            color: isSelected ? AppColor.whiteColor(context) : AppColor.accentColor(context),
          ),
          SizedBox(width: 6.w),
          Text(teacherClass.classNameAr ?? "فصل"),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          context.read<BusCubit>().selectTeacherClass(teacherClass);
        }
      },
      backgroundColor: AppColor.whiteColor(context),
      selectedColor: AppColor.accentColor(context),
      labelStyle: TextStyle(
        fontSize: 14.sp,
        color: isSelected ? AppColor.whiteColor(context) : const Color(0xFF6B7280),
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppColor.accentColor(context) : AppColor.whiteColor(context),
        ),
      ),
    );
  }

  Widget _buildClassChip(BusClass busClass, BuildContext context, BusClass? selectedClass) {
    final isSelected = selectedClass?.id == busClass.id;

    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.group_rounded,
            size: 16.w,
            color: isSelected ? AppColor.whiteColor(context) : busClass.classColor,
          ),
          SizedBox(width: 6.w),
          Text(busClass.className),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          context.read<BusCubit>().selectClass(busClass.id);
        }
      },
      backgroundColor: AppColor.whiteColor(context),
      selectedColor: busClass.classColor,
      labelStyle: TextStyle(
        fontSize: 14.sp,
        color: isSelected ? AppColor.whiteColor(context) : const Color(0xFF6B7280),
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? busClass.classColor : AppColor.whiteColor(context)),
      ),
    );
  }
}
