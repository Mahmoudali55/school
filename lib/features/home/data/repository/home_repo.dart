import 'package:flutter/material.dart';

import '../models/home_models.dart';

class HomeRepo {
  Future<StudentHomeModel> getStudentHomeData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return StudentHomeModel(
      userName: "محمد أحمد",
      userRole: "طالب",
      classInfo: "الصف العاشر - علمي",
      quickActions: [
        HomeQuickAction(
          title: "الجدول",
          icon: Icons.calendar_today,
          color: Colors.blue,
          onTap: () {},
        ),
        HomeQuickAction(
          title: "الواجبات",
          icon: Icons.assignment,
          color: Colors.orange,
          onTap: () {},
        ),
        HomeQuickAction(title: "النتائج", icon: Icons.grade, color: Colors.green, onTap: () {}),
        HomeQuickAction(title: "الغياب", icon: Icons.person_off, color: Colors.red, onTap: () {}),
      ],
      nextClass: NextClass(
        subject: "الفيزياء",
        time: "09:00 ص",
        room: "مختبر 1",
        teacher: "أ. أحمد علي",
      ),
      tasks: [
        UpcomingTask(title: "حل مسائل الميكانيكا", subject: "الفيزياء", dueDate: "غداً"),
        UpcomingTask(title: "قراءة الفصل الثالث", subject: "اللغة العربية", dueDate: "بعد غد"),
      ],
      notifications: [
        HomeNotification(
          title: "تم إضافة تقييم جديد في الرياضيات",
          time: "منذ ساعتين",
          type: "grade",
        ),
        HomeNotification(title: "موعد الرحلة المدرسية القادم", time: "منذ 5 ساعات", type: "event"),
      ],
    );
  }

  Future<TeacherHomeModel> getTeacherHomeData() async {
    return TeacherHomeModel(
      userName: "أ. أحمد محمد",
      userRole: "معلم",
      subjects: ["الفيزياء - الصف 10أ", "الفيزياء - الصف 10ب", "الرياضيات - الصف 9أ"],
      stats: {"طلاب": "95", "فصول": "3", "مهام": "5"},
      quickActions: [
        HomeQuickAction(
          title: "رصد الحضور",
          icon: Icons.check_circle,
          color: Colors.green,
          onTap: () {},
        ),
        HomeQuickAction(
          title: "إضافة واجب",
          icon: Icons.add_task,
          color: Colors.blue,
          onTap: () {},
        ),
        HomeQuickAction(
          title: "التقارير",
          icon: Icons.bar_chart,
          color: Colors.purple,
          onTap: () {},
        ),
      ],
      schedule: [
        ScheduleItem(time: "08:00 ص", subject: "الفيزياء", className: "10أ"),
        ScheduleItem(time: "09:30 ص", subject: "الرياضيات", className: "9أ"),
      ],
    );
  }

  Future<AdminHomeModel> getAdminHomeData() async {
    return AdminHomeModel(
      userName: "أ. خالد حسن",
      userRole: "مدير",
      metrics: {
        "الطلاب": {"value": "1250", "trend": "+5%"},
        "المعلمون": {"value": "85", "trend": "0%"},
        "نسبة الحضور": {"value": "94%", "trend": "+2%"},
      },
      quickActions: [
        HomeQuickAction(
          title: "إدارة المستخدمين",
          icon: Icons.people,
          color: Colors.blue,
          onTap: () {},
        ),
        HomeQuickAction(
          title: "الإعدادات العامة",
          icon: Icons.settings,
          color: Colors.grey,
          onTap: () {},
        ),
        HomeQuickAction(
          title: "الرسائل الجماعية",
          icon: Icons.campaign,
          color: Colors.orange,
          onTap: () {},
        ),
      ],
      alerts: [
        AdminAlert(title: "طلب صيانة مختبر العلوم", time: "منذ ساعة", severity: "high"),
        AdminAlert(title: "نقص في عجز الميزانية", time: "منذ يوم", severity: "medium"),
      ],
    );
  }

  Future<ParentHomeModel> getParentHomeData() async {
    final students = [
      StudentMiniInfo(name: "أحمد", grade: "الصف الرابع", school: "المدرسة الابتدائية"),
      StudentMiniInfo(name: "ليلى", grade: "الصف الثامن", school: "المدرسة المتوسطة"),
    ];
    return ParentHomeModel(
      userName: "أحمد محمد",
      userRole: "ولي أمر",
      students: students,
      selectedStudent: students[0],
      quickActions: [
        HomeQuickAction(
          title: "تتبع الحافلة",
          icon: Icons.directions_bus,
          color: Colors.blue,
          onTap: () {},
        ),
        HomeQuickAction(
          title: "الوضع المالي",
          icon: Icons.account_balance_wallet,
          color: Colors.green,
          onTap: () {},
        ),
        HomeQuickAction(title: "التواصل", icon: Icons.message, color: Colors.orange, onTap: () {}),
      ],
    );
  }
}
