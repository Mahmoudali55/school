import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainTrackingCardWidget extends StatelessWidget {
  final Map<String, dynamic> selectedBusData;
  final Animation<double> busAnimation;
  final VoidCallback onCallDriver;
  final VoidCallback onRefreshLocation;
  final VoidCallback onSendAlert;

  const MainTrackingCardWidget({
    super.key,
    required this.selectedBusData,
    required this.busAnimation,
    required this.onCallDriver,
    required this.onRefreshLocation,
    required this.onSendAlert,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: busAnimation,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.all(16.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Transform.translate(
                offset: Offset(busAnimation.value, 0),
                child: Icon(
                  Icons.directions_bus_rounded,
                  size: 80.w,
                  color: selectedBusData['busColor'],
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _actionButton(Icons.call, "اتصال بالسائق", onCallDriver),
                  _actionButton(Icons.refresh, "تحديث الموقع", onRefreshLocation),
                  _actionButton(Icons.warning, "إرسال تنبيه", onSendAlert),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.purple, size: 24.w),
          ),
        ),
        SizedBox(height: 6.h),
        Text(label, style: TextStyle(fontSize: 12.sp)),
      ],
    );
  }
}
