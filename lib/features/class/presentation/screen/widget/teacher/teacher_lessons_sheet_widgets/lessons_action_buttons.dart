import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class LessonsActionButtons extends StatelessWidget {
  final VoidCallback onCreate;
  final VoidCallback onCancel;

  const LessonsActionButtons({super.key, required this.onCreate, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(text: AppLocalKay.new_class.tr(), radius: 12, onPressed: onCreate),
        ),
        Gap(12.w),
        Expanded(
          child: CustomButton(text: AppLocalKay.cancel.tr(), radius: 12, onPressed: onCancel),
        ),
      ],
    );
  }
}
