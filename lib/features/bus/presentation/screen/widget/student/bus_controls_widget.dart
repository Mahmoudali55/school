import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
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
            text: AppLocalKay.update_location.tr(),
            icon: Icons.refresh_rounded,
            color: AppColor.primaryColor(context),
            onPressed: refreshLocation,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ControlButton(
            text: isBusMoving ? AppLocalKay.stop.tr() : AppLocalKay.start.tr(),
            icon: isBusMoving ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: AppColor.accentColor(context),
            onPressed: toggleBusMovement,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ControlButton(
            text: AppLocalKay.call_driver.tr(),
            icon: Icons.phone_rounded,
            color: AppColor.secondAppColor(context),
            onPressed: callDriver,
          ),
        ),
      ],
    );
  }
}
