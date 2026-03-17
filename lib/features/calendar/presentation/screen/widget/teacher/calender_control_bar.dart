import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColor.whiteColor(context),
            border: Border(
              top: BorderSide(color: AppColor.greyColor(context).withOpacity(0.05)),
              bottom: BorderSide(color: AppColor.greyColor(context).withOpacity(0.05)),
            ),
          ),
          child: Column(
            children: [
              // شريط العرض والتنقل
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.greyColor(context).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.all(4.w),
                      child: ViewSelectorWidget(
                        currentView: state.currentView,
                        onViewChanged: (view) {
                          context.read<CalendarCubit>().changeView(view);
                        },
                      ),
                    ),
                  ),
                  Gap(12.w),
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
