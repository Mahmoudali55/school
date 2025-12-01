import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/calendar/data/model/calendar_event_model.dart';

class ViewSelectorWidget extends StatelessWidget {
  final CalendarView currentView;
  final Function(CalendarView) onViewChanged;

  const ViewSelectorWidget({super.key, required this.currentView, required this.onViewChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildViewButton("شهري", CalendarView.monthly, context),
          _buildViewButton("أسبوعي", CalendarView.weekly, context),
          _buildViewButton("يومي", CalendarView.daily, context),
        ],
      ),
    );
  }

  Widget _buildViewButton(String text, CalendarView view, BuildContext context) {
    bool isSelected = currentView == view;
    return Expanded(
      child: GestureDetector(
        onTap: () => onViewChanged(view),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? AppColor.accentColor(context) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColor.whiteColor(context) : AppColor.greyColor(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
