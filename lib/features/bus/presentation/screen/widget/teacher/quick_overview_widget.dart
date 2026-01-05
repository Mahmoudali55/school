import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_cubit.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_state.dart';

class QuickOverviewWidget extends StatelessWidget {
  const QuickOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusCubit, BusState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E293B), Color(0xFF334155)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildOverviewItem(
                state.overviewStats['totalClasses'].toString(),
                "الفصول",
                Icons.class_rounded,
                const Color(0xFF10B981),
              ),
              _buildOverviewItem(
                state.overviewStats['totalStudents'].toString(),
                "الطلاب",
                Icons.people_rounded,
                const Color(0xFF3B82F6),
              ),
              _buildOverviewItem(
                state.overviewStats['closestArrival'].toString(),
                "أقرب وصول",
                Icons.schedule_rounded,
                const Color(0xFFF59E0B),
              ),
              _buildOverviewItem(
                state.overviewStats['attendanceRate'].toString(),
                "الحضور",
                Icons.percent_rounded,
                const Color(0xFFEC4899),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 24.w),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: const Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
