import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_template/core/custom_widgets/custom_app_bar/custom_app_bar.dart';
import 'package:my_template/core/theme/app_colors.dart';
import 'package:my_template/core/theme/app_text_style.dart';
import 'package:my_template/core/utils/app_local_kay.dart';
import 'package:my_template/features/notifications/presentation/screen/widget/notification_Item_widget.dart';
import 'package:my_template/features/notifications/presentation/screen/widget/parent/notification_section_widget.dart';

class NotificationsParentScreen extends StatelessWidget {
  const NotificationsParentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(
        context,
        centerTitle: true,

        title: Text(
          AppLocalKay.notification.tr(),
          style: AppTextStyle.titleLarge(
            context,
          ).copyWith(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.w, color: AppColor.blackColor(context)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  // إشعارات اليوم
                  NotificationSectionWidget(
                    title: "اليوم",
                    notifications: [
                      NotificationItemWidget(
                        icon: Icons.warning_amber_rounded,
                        iconColor: Color(0xFFDC2626),
                        iconBgColor: Color(0xFFFEF2F2),
                        title: "غياب الطالب",
                        message: "تم تسجيل غياب الطالب أحمد اليوم",
                        time: "منذ ساعتين",
                        isUrgent: true,
                        isRead: false,
                      ),
                      NotificationItemWidget(
                        icon: Icons.school,
                        iconColor: Color(0xFF10B981),
                        iconBgColor: Color(0xFFD1FAE5),
                        title: "تسليم الواجب",
                        message: "تم تسليم واجب الرياضيات بنجاح",
                        time: "منذ ٤ ساعات",
                        isUrgent: false,
                        isRead: true,
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // إشعارات الأمس
                  NotificationSectionWidget(
                    title: "الأمس",
                    notifications: [
                      NotificationItemWidget(
                        icon: Icons.assignment,
                        iconColor: Color(0xFF2E5BFF),
                        iconBgColor: Color(0xFFEFF6FF),
                        title: "تقرير سلوكي",
                        message: "تقرير سلوكي جديد للطالب أحمد",
                        time: "منذ يوم",
                        isUrgent: false,
                        isRead: true,
                      ),
                      NotificationItemWidget(
                        icon: Icons.celebration,
                        iconColor: Color(0xFF7C3AED),
                        iconBgColor: Color(0xFFF3E8FF),
                        title: "فعالية المدرسة",
                        message: "فعالية رياضية غداً في الساحة",
                        time: "منذ يوم",
                        isUrgent: false,
                        isRead: true,
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // إشعارات هذا الأسبوع
                  NotificationSectionWidget(
                    title: "هذا الأسبوع",
                    notifications: [
                      NotificationItemWidget(
                        icon: Icons.payments,
                        iconColor: Color(0xFFF59E0B),
                        iconBgColor: Color(0xFFFFFBEB),
                        title: "رسوم مدرسية",
                        message: "آخر موعد لدفع الرسوم ٠٥/١١/٢٠٢٥",
                        time: "منذ ٣ أيام",
                        isUrgent: true,
                        isRead: true,
                      ),
                      NotificationItemWidget(
                        icon: Icons.event,
                        iconColor: Color(0xFFEC4899),
                        iconBgColor: Color(0xFFFCE7F3),
                        title: "اجتماع أولياء الأمور",
                        message: "سيتم عقد اجتماع أولياء الأمور الأسبوع القادم",
                        time: "منذ ٤ أيام",
                        isUrgent: false,
                        isRead: true,
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
