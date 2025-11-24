import 'package:flutter/material.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';

class ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> studentData;
  const ProfileHeader({super.key, required this.studentData});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff1976D2), Color(0xff42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColor.whiteColor(context)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColor.whiteColor(context),
            child: Icon(Icons.person, size: 50, color: Colors.blue.shade700),
          ),
          const SizedBox(height: 12),
          Text(
            studentData['name'].toString(),
            style: AppTextStyle.titleLarge(context, color: AppColor.whiteColor(context)),
          ),
          Text(
            studentData['email'].toString(),
            style: AppTextStyle.titleSmall(context, color: AppColor.whiteColor(context)),
          ),
        ],
      ),
    );
  }
}
