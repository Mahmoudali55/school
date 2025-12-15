import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/setting/presentation/execution/edit_profile_screen.dart';

class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: AppColor.primaryColor(context).withOpacity(0.1),
              child: Icon(Icons.school, size: 30.w, color: AppColor.primaryColor(context)),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أحمد المدير',
                    style: AppTextStyle.headlineMedium(
                      context,
                      color: const Color(0xFF1F2937),
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'مدير المدرسة',
                    style: AppTextStyle.bodyMedium(context, color: AppColor.hintColor(context)),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'admin@school.edu',
                    style: AppTextStyle.bodyMedium(context, color: AppColor.hintColor(context)),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit, color: AppColor.primaryColor(context)),
              onPressed: () => editProfile(context),
            ),
          ],
        ),
      ),
    );
  }

  editProfile(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
  }
}
