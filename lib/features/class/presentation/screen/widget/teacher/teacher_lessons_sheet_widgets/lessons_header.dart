import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class LessonsHeader extends StatelessWidget {
  const LessonsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: AppColor.primaryColor(context).withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.menu_book_rounded, color: AppColor.primaryColor(context)),
        ),
        Gap(12.w),
        Expanded(
          child: Text(
            AppLocalKay.lessons.tr(),
            style: AppTextStyle.headlineSmall(context).copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
      ],
    );
  }
}
