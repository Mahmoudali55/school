import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/data/model/bus_tracking_models.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_tracking_cubit.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_tracking_state.dart';

class StudentsOnBusWidget extends StatelessWidget {
  const StudentsOnBusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusTrackingCubit, BusTrackingState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColor.whiteColor(context),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor(context).withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalKay.busstudents.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9800).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${state.studentsOnBus.length} طالب",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFFFF9800),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300.h),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state.studentsOnBus.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) =>
                      _buildStudentItem(state.studentsOnBus[index], context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStudentItem(StudentOnBus student, BuildContext context) {
    Color statusColor;
    IconData statusIcon;

    switch (student.status) {
      case 'في الحافلة':
        statusColor = const Color(0xFF4CAF50);
        statusIcon = Icons.directions_bus_rounded;
        break;
      case 'في المحطة':
        statusColor = const Color(0xFF2196F3);
        statusIcon = Icons.location_on_rounded;
        break;
      case 'في الطريق':
        statusColor = const Color(0xFFFF9800);
        statusIcon = Icons.directions_walk_rounded;
        break;
      default:
        statusColor = const Color(0xFF9E9E9E);
        statusIcon = Icons.person_rounded;
    }

    Color attendanceColor;
    switch (student.attendance) {
      case 'حاضر':
        attendanceColor = const Color(0xFF4CAF50);
        break;
      case 'متأخر':
        attendanceColor = const Color(0xFFFF9800);
        break;
      case 'متوقع':
        attendanceColor = const Color(0xFF2196F3);
        break;
      default:
        attendanceColor = const Color(0xFF9E9E9E);
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // Student Avatar
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: student.avatarColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded, color: student.avatarColor, size: 18.w),
          ),
          SizedBox(width: 8.w),
          // Student Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  student.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "${student.grade} • ${student.boardingStop}",
                  style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          // Status & Attendance
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 10.w, color: statusColor),
                    SizedBox(width: 4.w),
                    Text(
                      student.status,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: attendanceColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  student.attendance,
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: attendanceColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
