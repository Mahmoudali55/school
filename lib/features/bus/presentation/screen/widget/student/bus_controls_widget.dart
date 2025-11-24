import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/features/bus/presentation/screen/widget/student/control_button_widget.dart';

class BusControls extends StatelessWidget {
  final VoidCallback refreshLocation;
  final VoidCallback toggleBusMovement;
  final VoidCallback callDriver;
  final bool isBusMoving;

  const BusControls({
    super.key,
    required this.refreshLocation,
    required this.toggleBusMovement,
    required this.callDriver,
    required this.isBusMoving,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ControlButton(
            text: "تحديث الموقع",
            icon: Icons.refresh_rounded,
            color: const Color(0xFF2196F3),
            onPressed: refreshLocation,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ControlButton(
            text: isBusMoving ? "إيقاف الحركة" : "تشغيل الحركة",
            icon: isBusMoving ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: const Color(0xFFFF9800),
            onPressed: toggleBusMovement,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ControlButton(
            text: "اتصال بالسائق",
            icon: Icons.phone_rounded,
            color: const Color(0xFF4CAF50),
            onPressed: callDriver,
          ),
        ),
      ],
    );
  }
}
