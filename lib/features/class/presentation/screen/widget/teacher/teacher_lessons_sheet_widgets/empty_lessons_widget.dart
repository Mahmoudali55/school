import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';

class EmptyLessons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_outlined, size: 72, color: Colors.grey[300]),
          Gap(12.h),
          Text(
            AppLocalKay.no_lessons.tr(),
            style: AppTextStyle.bodyLarge(context).copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
