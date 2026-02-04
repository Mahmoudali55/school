import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class AssignmentsActionButtons extends StatelessWidget {
  final VoidCallback onCreate;
  final VoidCallback onCancel;

  const AssignmentsActionButtons({super.key, required this.onCreate, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            onPressed: onCreate,
            text: AppLocalKay.create_new_assignment.tr(),
            radius: 12,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomButton(text: AppLocalKay.cancel.tr(), radius: 12, onPressed: onCancel),
        ),
      ],
    );
  }
}
