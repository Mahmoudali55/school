import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/features/bus/data/model/admin_bus_model.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/bus_controls_widget.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/bus_status_header.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/map_section_widget.dart';

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
            child: MapSection(
              stops: widget.stops,
              busAnimation: widget.busAnimation,
              isBusMoving: widget.isBusMoving,
            ),
          ),

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
