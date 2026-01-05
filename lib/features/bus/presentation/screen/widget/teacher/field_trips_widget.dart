import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_cubit.dart';
import 'package:my_template/features/bus/presentation/cubit/bus_state.dart';

class FieldTripsWidget extends StatelessWidget {
  const FieldTripsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusCubit, BusState>(
      builder: (context, state) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalKay.travels.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${state.fieldTrips.length} رحلات",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF4CAF50),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              if (state.fieldTrips.isEmpty)
                _buildEmptyFieldTrips()
              else
                Column(
                  children: state.fieldTrips.map((trip) => _buildFieldTripItem(trip)).toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFieldTripItem(dynamic trip) {
    Color statusColor;
    switch (trip.status) {
      case 'مخطط':
        statusColor = const Color(0xFFFF9800);
        break;
      case 'مؤكد':
        statusColor = const Color(0xFF4CAF50);
        break;
      case 'ملغى':
        statusColor = const Color(0xFFF44336);
        break;
      default:
        statusColor = const Color(0xFF9E9E9E);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip Icon
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: trip.color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.travel_explore_rounded, size: 18.w, color: trip.color),
          ),
          SizedBox(width: 12.w),
          // Trip Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.tripName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "${trip.date} • ${trip.time}",
                  style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
                ),
                SizedBox(height: 4.h),
                Text(
                  "الحافلة: ${trip.bus} • ${trip.students}",
                  style: TextStyle(fontSize: 11.sp, color: const Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          // Status
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              trip.status,
              style: TextStyle(fontSize: 10.sp, color: statusColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFieldTrips() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Column(
        children: [
          Icon(Icons.travel_explore_outlined, size: 48.w, color: const Color(0xFF9CA3AF)),
          SizedBox(height: 12.h),
          Text(
            AppLocalKay.no_travels.tr(),
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            AppLocalKay.no_travels_hint.tr(),
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }
}
