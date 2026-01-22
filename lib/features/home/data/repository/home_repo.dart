import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/error/failures.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import 'package:my_template/features/home/data/models/parents_student_data_model.dart';
import 'package:my_template/features/home/data/models/student_absent_count_model.dart';

import '../models/home_models.dart';

abstract interface class HomeRepo {
  Future<Either<Failure, StudentHomeModel>> getStudentHomeData();
  Future<Either<Failure, TeacherHomeModel>> getTeacherHomeData();
  Future<Either<Failure, AdminHomeModel>> getAdminHomeData();
  Future<Either<Failure, ParentHomeModel>> getParentHomeData(int code);
  Future<Either<Failure, List<ParentsStudentData>>> ParentsStudent({required int code});
  Future<Either<Failure, List<StudentAbsentCount>>> studentAbsentCount({required int code});
}

class HomeRepoImpl implements HomeRepo {
  final ApiConsumer apiConsumer;
  HomeRepoImpl(this.apiConsumer);

  @override
  Future<Either<Failure, List<ParentsStudentData>>> ParentsStudent({required int code}) async {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.studentData,
          queryParameters: {"Code": code},
        );
        final String dataString = response['Data'];
        return ParentsStudentData.listFromDataString(dataString);
      },
    );
  }

  @override
  Future<Either<Failure, List<StudentAbsentCount>>> studentAbsentCount({required int code}) async {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.studentAbsentcount,
          queryParameters: {"Code": code},
        );
        final String dataString = response['Data'];
        return StudentAbsentCount.listFromDataString(dataString);
      },
    );
  }

  @override
  Future<Either<Failure, ParentHomeModel>> getParentHomeData(int code) async {
    final result = await ParentsStudent(code: code);
    return result.fold((failure) => Left(failure), (students) {
      if (students.isEmpty) return Left(ServerFailure("No students found for this parent"));

      final selected = students.first;
      return Right(
        ParentHomeModel(
          userName: HiveMethods.getUserName(),
          userRole: "ولي أمر",
          students: students
              .map(
                (s) => StudentMiniInfo(
                  name: s.studentName,
                  grade: "كود: ${s.studentCode}",
                  studentCode: s.studentCode,
                  school: "مدرسة التميز",
                ),
              )
              .toList(),
          selectedStudent: StudentMiniInfo(
            name: selected.studentName,
            grade: "كود: ${selected.studentCode}",
            studentCode: selected.studentCode,
            school: "مدرسة التميز",
          ),
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
            HomeQuickAction(
              title: "التواصل",
              icon: Icons.message,
              color: Colors.orange,
              onTap: () {},
            ),
          ],
        ),
      );
    });
  }

  @override
  Future<Either<Failure, AdminHomeModel>> getAdminHomeData() async {
    return Right(
      AdminHomeModel(
        userName: HiveMethods.getUserName(),
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
      ),
    );
  }

  @override
  Future<Either<Failure, StudentHomeModel>> getStudentHomeData() async {
    return Right(
      StudentHomeModel(
        userName: HiveMethods.getUserName(),
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
          HomeNotification(
            title: "موعد الرحلة المدرسية القادم",
            time: "منذ 5 ساعات",
            type: "event",
          ),
        ],
      ),
    );
  }

  @override
  Future<Either<Failure, TeacherHomeModel>> getTeacherHomeData() async {
    return Right(
      TeacherHomeModel(
        userName: HiveMethods.getUserName(),
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
      ),
    );
  }
}
