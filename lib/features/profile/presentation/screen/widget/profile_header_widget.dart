import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/features/profile/data/model/student_profile_model.dart';

class ProfileHeader extends StatelessWidget {
  final StudentProfileModel studentData;
  const ProfileHeader({super.key, required this.studentData});

  @override
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)], // New vibrant gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.only(top: 50.h, bottom: 40.h, left: 20.w, right: 20.w),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20.sp),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 45.r,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50.sp, color: const Color(0xFF2E3192)),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              context.locale.languageCode == 'en'
                  ? studentData.firstNameEn.toString()
                  : studentData.firstNameAr.toString(),
              style: AppTextStyle.titleLarge(context).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                    color: Colors.black.withValues(alpha: 0.2),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                studentData.prioritySystemName.toString(),
                style: AppTextStyle.bodyMedium(
                  context,
                ).copyWith(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 30);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 15);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width - (size.width / 3.25), size.height - 40);
    var secondEndPoint = Offset(size.width, size.height - 10);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
