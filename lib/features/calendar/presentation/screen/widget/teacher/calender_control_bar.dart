import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/class_selector_widget.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/view_selector_widget.dart';

import '../../../cubit/calendar_cubit.dart';
import '../../../cubit/calendar_state.dart';

class ControlBarWidget extends StatelessWidget {
  const ControlBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          color: AppColor.whiteColor(context),
          child: Column(
            children: [
              // اختيار الصف
              ClassSelectorWidget(
                selectedClass: state.selectedClass,
                classes: state.classes,
                onChanged: (classInfo) {
                  context.read<CalendarCubit>().changeClass(classInfo);
                },
              ),
              SizedBox(height: 12.h),
              // شريط العرض والتنقل
              Row(
                children: [
                  Expanded(
                    child: ViewSelectorWidget(
                      currentView: state.currentView,
                      onViewChanged: (view) {
                        context.read<CalendarCubit>().changeView(view);
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  _buildNavigationButtons(context),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.accentColor(context).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.chevron_right_rounded, size: 20.w),
            onPressed: () => context.read<CalendarCubit>().goToPrevious(),
          ),
          Container(
            width: 1.w,
            height: 20.h,
            color: AppColor.accentColor(context).withOpacity(0.3),
          ),
          IconButton(
            icon: Icon(Icons.chevron_left_rounded, size: 20.w),
            onPressed: () => context.read<CalendarCubit>().goToNext(),
          ),
        ],
      ),
    );
  }
}
