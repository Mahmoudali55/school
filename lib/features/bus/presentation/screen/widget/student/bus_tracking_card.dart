import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/bus_controls_widget.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/bus_status_header.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/map_section_widget.dart';

class BusTrackingCard extends StatelessWidget {
  final Map<String, dynamic> busData;
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
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          BusStatusHeader(busData: busData),
          SizedBox(height: 20.h),
          MapSection(stops: stops, busAnimation: busAnimation, isBusMoving: isBusMoving),
          SizedBox(height: 20.h),
          BusControls(
            refreshLocation: refreshLocation,
            toggleBusMovement: toggleBusMovement,
            callDriver: callDriver,
            isBusMoving: isBusMoving,
          ),
        ],
      ),
    );
  }
}
