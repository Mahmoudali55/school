import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_tracking_cubit.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_tracking_state.dart';

class BusClassDetailsWidget extends StatelessWidget {
  const BusClassDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusTrackingCubit, BusTrackingState>(
      builder: (context, state) {
        if (state.selectedClass == null) {
          return Container();
        }

        final busClass = state.selectedClass!;

        return Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalKay.busdetails.tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 16.h),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 1.1,
                children: [
                  _buildDetailItem("الفصل", busClass.className, Icons.class_rounded, busClass),
                  _buildDetailItem("المادة", busClass.subject, Icons.book_rounded, busClass),
                  _buildDetailItem(
                    "الحافلة",
                    busClass.busNumber,
                    Icons.directions_bus_rounded,
                    busClass,
                  ),
                  _buildDetailItem("السائق", busClass.driverName, Icons.person_rounded, busClass),
                  _buildDetailItem(
                    "الوقت المتوقع",
                    busClass.estimatedArrival,
                    Icons.schedule_rounded,
                    busClass,
                  ),
                  _buildDetailItem(
                    "المحطة التالية",
                    busClass.nextStop,
                    Icons.flag_rounded,
                    busClass,
                  ),
                  _buildDetailItem(
                    "الطلاب على الحافلة",
                    busClass.studentsOnBus,
                    Icons.people_rounded,
                    busClass,
                  ),
                  _buildDetailItem(
                    "نسبة الحضور",
                    busClass.attendanceRate,
                    Icons.percent_rounded,
                    busClass,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String title, String value, IconData icon, dynamic busClass) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: busClass.classColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16.w, color: busClass.classColor),
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
          ),

          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
