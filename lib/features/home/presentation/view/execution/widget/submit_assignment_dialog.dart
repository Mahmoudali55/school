import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class SubmitAssignmentDialog extends StatelessWidget {
  const SubmitAssignmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalKay.submit_assignment.tr(), style: AppTextStyle.bodyMedium(context)),
      content: Text(AppLocalKay.submit_confirmation.tr(), style: AppTextStyle.bodyMedium(context)),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalKay.dialog_delete_cancel.tr()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: CustomButton(text: AppLocalKay.submit_assignment.tr(), radius: 12)),
          ],
        ),
      ],
    );
  }
}
