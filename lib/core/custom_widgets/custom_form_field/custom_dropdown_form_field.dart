import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';

class CustomDropdownFormField<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String errorText;
  final bool submitted;
  final String? hint;

  const CustomDropdownFormField({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    required this.errorText,
    required this.submitted,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      dropdownColor: AppColor.whiteColor(context),
      style: TextStyle(color: AppColor.blackColor(context), fontSize: 14.sp),
      autovalidateMode: submitted ? AutovalidateMode.always : AutovalidateMode.disabled,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        filled: true,
        fillColor: AppColor.textFormFillColor(context),
        errorText: submitted && value == null ? errorText : null,
      ),
      items: items,
      onChanged: onChanged,
      validator: (v) => v == null ? errorText : null,
    );
  }
}
