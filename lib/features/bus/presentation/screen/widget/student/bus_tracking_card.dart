import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/bus/data/model/admin_bus_model.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/bus_controls_widget.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/bus_status_header.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/map_section_widget.dart';
import 'package:my_template/features/bus/presentation/screen/widget/bus_map_widget.dart';

class BusTrackingCard extends StatefulWidget {
  final BusModel busData;
  final List<Map<String, dynamic>> stops;
  final Animation<double> busAnimation;
  final bool isBusMoving;
  final VoidCallback refreshLocation;
  final VoidCallback toggleBusMovement;
  final VoidCallback callDriver;

  const BusTrackingCard({
    super.key,
    required this.busData,
    required this.stops,
    required this.busAnimation,
    required this.isBusMoving,
    required this.refreshLocation,
    required this.toggleBusMovement,
    required this.callDriver,
  });

  @override
  State<BusTrackingCard> createState() => _BusTrackingCardState();
}

class _BusTrackingCardState extends State<BusTrackingCard> {
  bool _showMap = false;

  @override
  Widget build(BuildContext context) {
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
          BusStatusHeader(busData: widget.busData),
          SizedBox(height: 20.h),

          // Map or Animation Area
          SizedBox(
            height: 200.h,
            child: _showMap
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BusMapWidget(
                      busLat: widget.busData.lat ?? 24.7136,
                      busLng: widget.busData.lng ?? 46.6753,
                      busId: widget.busData.busNumber,
                      busName: widget.busData.busNumber,
                    ),
                  )
                : MapSection(
                    stops: widget.stops,
                    busAnimation: widget.busAnimation,
                    isBusMoving: widget.isBusMoving,
                  ),
          ),

          SizedBox(height: 10.h),

          // Toggle Button
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: InkWell(
              onTap: () {
                setState(() {
                  _showMap = !_showMap;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E8),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColor.primaryColor(context).withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _showMap ? Icons.visibility_off : Icons.map_outlined,
                      size: 14.w,
                      color: AppColor.primaryColor(context),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      _showMap ? "إخفاء الخريطة" : "عرض الخريطة الحية",
                      style: AppTextStyle.bodySmall(context).copyWith(
                        color: AppColor.primaryColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 20.h),
          BusControls(
            refreshLocation: widget.refreshLocation,
            toggleBusMovement: widget.toggleBusMovement,
            callDriver: widget.callDriver,
            isBusMoving: widget.isBusMoving,
          ),
        ],
      ),
    );
  }
}
