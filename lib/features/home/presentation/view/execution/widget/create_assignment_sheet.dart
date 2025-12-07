import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/buttons/custom_button.dart';
import 'package:my_template/core/custom_widgets/custom_form_field/custom_form_field.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class CreateAssignmentSheet extends StatelessWidget {
  const CreateAssignmentSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalKay.create_new_assignment.tr(),
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          CustomFormField(title: AppLocalKay.assignment_title.tr(), radius: 12),
          SizedBox(height: 16.h),
          CustomFormField(title: AppLocalKay.assignment_description.tr(), radius: 12),
          SizedBox(height: 16.h),
          CustomButton(
            text: AppLocalKay.save.tr(),
            radius: 12,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
