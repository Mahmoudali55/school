import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/calendar/presentation/screen/widget/teacher/view_selector_widget.dart';

import '../../../cubit/calendar_cubit.dart';
import '../../../cubit/calendar_state.dart';

class ControlBarWidget extends StatefulWidget {
  const ControlBarWidget({super.key});

  @override
  State<ControlBarWidget> createState() => _ControlBarWidgetState();
}

class _ControlBarWidgetState extends State<ControlBarWidget> {
  @override
  void initState() {
    super.initState();
    // Fetch teacher classes when widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CalendarCubit>().loadTeacherClasses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          color: AppColor.whiteColor(context),
          child: Column(
            children: [
              // اختيار الصف مع معالجة حالة التحميل
              //_buildClassSelector(context, state),
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

  // Widget _buildClassSelector(BuildContext context, CalendarState state) {
  //   // Show loading indicator while fetching classes
  //   if (state.classesLoading) {
  //     return Container(
  //       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
  //       decoration: BoxDecoration(
  //         color: AppColor.whiteColor(context),
  //         borderRadius: BorderRadius.circular(8),
  //         border: Border.all(color: AppColor.accentColor(context).withOpacity(0.3)),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           SizedBox(
  //             width: 16.w,
  //             height: 16.h,
  //             child: CircularProgressIndicator(
  //               strokeWidth: 2,
  //               valueColor: AlwaysStoppedAnimation<Color>(AppColor.accentColor(context)),
  //             ),
  //           ),
  //           SizedBox(width: 8.w),
  //           Text('جاري تحميل الصفوف...', style: TextStyle(fontSize: 14.sp)),
  //         ],
  //       ),
  //     );
  //   }

  //   // Show error message if fetching failed
  //   if (state.classesError != null) {
  //     return Container(
  //       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
  //       decoration: BoxDecoration(
  //         color: Colors.red.shade50,
  //         borderRadius: BorderRadius.circular(8),
  //         border: Border.all(color: Colors.red.shade200),
  //       ),
  //       child: Row(
  //         children: [
  //           Icon(Icons.error_outline, color: Colors.red, size: 20.w),
  //           SizedBox(width: 8.w),
  //           Expanded(
  //             child: Text(
  //               state.classesError!,
  //               style: TextStyle(fontSize: 12.sp, color: Colors.red.shade700),
  //             ),
  //           ),
  //           IconButton(
  //             icon: Icon(Icons.refresh, color: Colors.red, size: 20.w),
  //             onPressed: () => context.read<CalendarCubit>().loadTeacherClasses(),
  //           ),
  //         ],
  //       ),
  //     );
  //   }

  // Show class selector when data is loaded
  //   return ClassSelectorWidget(
  //     selectedClass: state.selectedClass,
  //     classes: state.classes,
  //     onChanged: (classInfo) {
  //       context.read<CalendarCubit>().changeClass(classInfo);
  //     },
  //   );
  // }

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
