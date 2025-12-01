import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/data/model/bus_tracking_models.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_tracking_cubit.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_tracking_state.dart';

class MainTrackingCard extends StatelessWidget {
  final Animation<double> busAnimation;

  const MainTrackingCard({super.key, required this.busAnimation});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusTrackingCubit, BusTrackingState>(
      builder: (context, state) {
        if (state.selectedClass == null) {
          return Container(
            margin: EdgeInsets.all(16.w),
            child: const Center(child: Text('اختر فصلًا')),
          );
        }

        return Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColor.whiteColor(context),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor(context).withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              // Class Header
              _buildClassHeader(state.selectedClass!),
              SizedBox(height: 20.h),
              // Map Section
              _buildMapSection(state.selectedClass!, context),
              SizedBox(height: 20.h),
              // Tracking Actions
              _buildTrackingActions(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClassHeader(BusClass busClass) {
    Color statusColor;
    IconData statusIcon;

    switch (busClass.status) {
      case 'في الطريق':
        statusColor = const Color(0xFF4CAF50);
        statusIcon = Icons.directions_bus_rounded;
        break;
      case 'في المحطة':
        statusColor = const Color(0xFF2196F3);
        statusIcon = Icons.location_on_rounded;
        break;
      case 'متأخرة':
        statusColor = const Color(0xFFFF9800);
        statusIcon = Icons.schedule_rounded;
        break;
      default:
        statusColor = const Color(0xFF9E9E9E);
        statusIcon = Icons.directions_bus_rounded;
    }

    return Row(
      children: [
        // Class Avatar
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: busClass.classColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.class_rounded, color: busClass.classColor, size: 24.w),
        ),
        SizedBox(width: 12.w),
        // Class Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                busClass.className,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              Text(
                "${busClass.subject} • ${busClass.studentsOnBus} على الحافلة",
                style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6B7280)),
              ),
            ],
          ),
        ),
        // Status Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(statusIcon, size: 14.w, color: statusColor),
              SizedBox(width: 4.w),
              Text(
                busClass.status,
                style: TextStyle(fontSize: 12.sp, color: statusColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMapSection(BusClass busClass, BuildContext context) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: busClass.busColor.withOpacity(0.3)),
      ),
      child: Stack(
        children: [
          // Route Line
          Positioned(
            top: 90.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              height: 4.h,
              decoration: BoxDecoration(
                color: busClass.busColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // School Icon
          Positioned(
            right: 20.w,
            top: 80.h,
            child: Column(
              children: [
                Icon(Icons.school_rounded, color: const Color(0xFF2196F3), size: 24.w),
                SizedBox(height: 4.h),
                Text(
                  "المدرسة",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Random Stops
          ..._generateRandomStops(context),
          // Animated Bus
          _buildAnimatedBus(busClass, context),
        ],
      ),
    );
  }

  List<Widget> _generateRandomStops(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final random = Random();

    return List.generate(3, (index) {
      final position = 20 + (random.nextDouble() * (screenWidth - 60));
      return Positioned(
        left: position,
        top: 80.h,
        child: Column(
          children: [
            Icon(Icons.person_pin_circle_rounded, color: const Color(0xFFFF9800), size: 20.w),
            SizedBox(height: 4.h),
            Text(
              "محطة ${index + 1}",
              style: TextStyle(fontSize: 8.sp, color: const Color(0xFF6B7280)),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAnimatedBus(BusClass busClass, BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.35,
      top: 70.h,
      child: AnimatedBuilder(
        animation: busAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, busAnimation.value),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColor.whiteColor(context),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.blackColor(context).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.directions_bus_rounded, color: busClass.busColor, size: 32.w),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrackingActions(BuildContext context) {
    final cubit = context.read<BusTrackingCubit>();
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            AppLocalKay.check_in.tr(),
            Icons.people_alt_rounded,
            const Color(0xFF4CAF50),
            () => _takeAttendance(cubit, context),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionButton(
            AppLocalKay.ConnectDriver.tr(),
            Icons.phone_rounded,
            const Color(0xFF2196F3),
            () => _callDriver(context),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildActionButton(
            AppLocalKay.ParentNotification.tr(),
            Icons.notifications_rounded,
            const Color(0xFFFF9800),
            () => _notifyParents(context),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 15.w),
            SizedBox(width: 10.w),
            Text(
              text,
              style: TextStyle(fontSize: 8.sp, color: color),
            ),
          ],
        ),
      ),
    );
  }

  void _takeAttendance(BusTrackingCubit cubit, BuildContext context) {
    cubit.takeAttendance();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم تسجيل الحضور بنجاح'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
    );
  }

  void _callDriver(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.ParentNotification.tr(), style: AppTextStyle.bodyMedium(context)),
        content: Text(
          AppLocalKay.ConnectDriverHint.tr(),
          style: AppTextStyle.bodyMedium(context, color: AppColor.greyColor(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalKay.dialog_delete_cancel.tr(),
              style: AppTextStyle.bodyMedium(context, color: AppColor.primaryColor(context)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // تنفيذ الاتصال
            },
            child: Text(
              AppLocalKay.Connect.tr(),
              style: AppTextStyle.bodyMedium(context, color: AppColor.primaryColor(context)),
            ),
          ),
        ],
      ),
    );
  }

  void _notifyParents(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalKay.ParentNotification.tr(), style: AppTextStyle.bodyMedium(context)),
        content: Text(
          AppLocalKay.ParentNotification.tr(),
          style: AppTextStyle.bodySmall(context, color: AppColor.greyColor(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalKay.dialog_delete_cancel.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('تم إرسال الإشعار بنجاح'),
                  backgroundColor: const Color(0xFFFF9800),
                ),
              );
            },
            child: Text(
              AppLocalKay.send_notification.tr(),
              style: AppTextStyle.bodyMedium(context, color: AppColor.primaryColor(context)),
            ),
          ),
        ],
      ),
    );
  }
}
