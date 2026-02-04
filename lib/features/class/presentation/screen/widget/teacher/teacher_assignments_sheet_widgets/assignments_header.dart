import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class AssignmentsHeader extends StatelessWidget {
  const AssignmentsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black),
            ),
            child: const Icon(Icons.close, size: 18),
          ),
        ),
        const Spacer(),
        Text(AppLocalKay.tasks.tr(), style: AppTextStyle.titleLarge(context)),
        const Spacer(),
        const SizedBox(width: 32),
      ],
    );
  }
}
