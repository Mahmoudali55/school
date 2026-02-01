import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';

class EmergencyButton extends StatelessWidget {
  final VoidCallback showDialogCallback;

  const EmergencyButton({super.key, required this.showDialogCallback});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColor.errorColor(context),
      onPressed: showDialogCallback,
      child: Icon(Icons.emergency_rounded, color: AppColor.whiteColor(context)),
    );
  }
}
