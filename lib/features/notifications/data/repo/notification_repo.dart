import 'package:flutter/material.dart';
import 'package:my_template/features/notifications/data/model/notification_model.dart';

class NotificationRepo {
  Future<List<NotificationModel>> getNotifications() async {
    // Mocking an API delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      NotificationModel(
        id: '1',
        title: "غياب الطالب",
        message: "تم تسجيل غياب الطالب أحمد اليوم",
        time: "منذ ساعتين",
        isUrgent: true,
        isRead: false,
        icon: Icons.warning_amber_rounded,
        iconColor: const Color(0xFFDC2626),
        iconBgColor: const Color(0xFFFEF2F2),
        category: "اليوم",
      ),
      NotificationModel(
        id: '2',
        title: "تسليم الواجب",
        message: "تم تسليم واجب الرياضيات بنجاح",
        time: "منذ ٤ ساعات",
        isUrgent: false,
        isRead: true,
        icon: Icons.school,
        iconColor: const Color(0xFF10B981),
        iconBgColor: const Color(0xFFD1FAE5),
        category: "اليوم",
      ),
      NotificationModel(
        id: '3',
        title: "تقرير سلوكي",
        message: "تقرير سلوكي جديد للطالب أحمد",
        time: "منذ يوم",
        isUrgent: false,
        isRead: true,
        icon: Icons.assignment,
        iconColor: const Color(0xFF2E5BFF),
        iconBgColor: const Color(0xFFEFF6FF),
        category: "الأمس",
      ),
      NotificationModel(
        id: '4',
        title: "فعالية المدرسة",
        message: "فعالية رياضية غداً في الساحة",
        time: "منذ يوم",
        isUrgent: false,
        isRead: true,
        icon: Icons.celebration,
        iconColor: const Color(0xFF7C3AED),
        iconBgColor: const Color(0xFFF3E8FF),
        category: "الأمس",
      ),
      NotificationModel(
        id: '5',
        title: "رسوم مدرسية",
        message: "آخر موعد لدفع الرسوم ٠٥/١١/٢٠٢٥",
        time: "منذ ٣ أيام",
        isUrgent: true,
        isRead: true,
        icon: Icons.payments,
        iconColor: const Color(0xFFF59E0B),
        iconBgColor: const Color(0xFFFFFBEB),
        category: "هذا الأسبوع",
      ),
      NotificationModel(
        id: '6',
        title: "اجتماع أولياء الأمور",
        message: "سيتم عقد اجتماع أولياء الأمور الأسبوع القادم",
        time: "منذ ٤ أيام",
        isUrgent: false,
        isRead: true,
        icon: Icons.event,
        iconColor: const Color(0xFFEC4899),
        iconBgColor: const Color(0xFFFCE7F3),
        category: "هذا الأسبوع",
      ),
    ];
  }
}
