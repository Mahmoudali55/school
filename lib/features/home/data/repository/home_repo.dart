import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/cache/hive/hive_methods.dart';
import 'package:my_template/core/error/failures.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import 'package:my_template/features/home/data/models/add_permissions_mobile_model.dart';
import 'package:my_template/features/home/data/models/add_permissions_response_model.dart';
import 'package:my_template/features/home/data/models/add_uniform_request_model.dart';
import 'package:my_template/features/home/data/models/add_uniform_response_model.dart';
import 'package:my_template/features/home/data/models/edit_permissions_mobile_request_model.dart';
import 'package:my_template/features/home/data/models/edit_permissions_mobile_response_model.dart';
import 'package:my_template/features/home/data/models/edit_uniform_request_model.dart';
import 'package:my_template/features/home/data/models/edit_uniform_response_model.dart';
import 'package:my_template/features/home/data/models/get_permissions_mobile_model.dart';
import 'package:my_template/features/home/data/models/get_uniform_data_model.dart';
import 'package:my_template/features/home/data/models/parent_balance_model.dart';
import 'package:my_template/features/home/data/models/parents_student_data_model.dart';
import 'package:my_template/features/home/data/models/student_absent_count_model.dart';
import 'package:my_template/features/home/data/models/student_absent_data_model.dart';
import 'package:my_template/features/home/data/models/student_balance_model.dart';
import 'package:my_template/features/home/data/models/student_course_degree_model.dart';
import 'package:my_template/features/home/data/models/teacher_level_model.dart';

import '../models/home_models.dart';

abstract interface class HomeRepo {
  Future<Either<Failure, StudentHomeModel>> getStudentHomeData();
  Future<Either<Failure, TeacherHomeModel>> getTeacherHomeData();
  Future<Either<Failure, AdminHomeModel>> getAdminHomeData();
  Future<Either<Failure, ParentHomeModel>> getParentHomeData(int code);
  Future<Either<Failure, List<ParentsStudentData>>> ParentsStudent({required int code});
  Future<Either<Failure, List<StudentAbsentData>>> studentAbsentDataDetails({required int code});
  Future<Either<Failure, List<StudentAbsentCount>>> studentAbsentCount({required int code});
  Future<Either<Failure, List<ParentBalanceModel>>> parentBalance({required int code});
  Future<Either<Failure, List<StudentBalanceModel>>> studentBalance({required int code});
  Future<Either<Failure, AddPermissionsResponse>> addPermissions({
    required AddPermissionsMobile request,
  });

  Future<Either<Failure, List<StudentCourseDegree>>> studentCourseDegree({
    required int code,
    int? monthNo,
  });
  Future<Either<Failure, GetPermissionsMobile>> getPermissions({required int code});

  Future<Either<Failure, EditPermissionsMobileResponse>> editPermissions({
    required EditPermissionsMobileRequest request,
  });

  Future<Either<Failure, AddUniformResponseModel>> addUniform({
    required AddUniformRequestModel request,
  });

  Future<Either<Failure, GetUniformDataResponse>> getUniforms({required int code, int? id});

  Future<Either<Failure, EditUniformResponse>> editUniform({
    required EditUniformRequestModel request,
  });

  Future<Either<Failure, List<TeacherLevelModel>>> teacherLevel({required int stageCode});
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
        if (dataString.isEmpty || dataString == "[]") return [];
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
        if (dataString.isEmpty || dataString == "[]") return [];
        return StudentAbsentCount.listFromDataString(dataString);
      },
    );
  }

  @override
  Future<Either<Failure, List<StudentAbsentData>>> studentAbsentDataDetails({
    required int code,
  }) async {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.studentAbsentDataDetails,
          queryParameters: {"Code": code},
        );
        final String dataString = response['Data'];
        if (dataString.isEmpty || dataString == "[]") return [];
        return StudentAbsentData.listFromDataString(dataString);
      },
    );
  }

  @override
  Future<Either<Failure, List<ParentBalanceModel>>> parentBalance({required int code}) async {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.parentBalance,
          queryParameters: {"Code": code},
        );
        final String dataString = response['Data'];
        if (dataString.isEmpty || dataString == "[]") return [];
        return ParentBalanceModel.listFromDataString(dataString);
      },
    );
  }

  @override
  Future<Either<Failure, List<StudentBalanceModel>>> studentBalance({required int code}) async {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.studentBalance,
          queryParameters: {"Code": code},
        );
        final String dataString = response['Data'];
        if (dataString.isEmpty || dataString == "[]") return [];
        return StudentBalanceModel.listFromDataString(dataString);
      },
    );
  }

  @override
  Future<Either<Failure, EditPermissionsMobileResponse>> editPermissions({
    required EditPermissionsMobileRequest request,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.put(
          EndPoints.editPermissionsMobile,
          body: request.toJson(),
        );
        return EditPermissionsMobileResponse.fromJson(response);
      },
    );
  }

  @override
  Future<Either<Failure, AddPermissionsResponse>> addPermissions({
    required AddPermissionsMobile request,
  }) async {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.post(EndPoints.addPermissions, body: request.toJson());

        return AddPermissionsResponse.fromJson(response);
      },
    );
  }

  @override
  Future<Either<Failure, EditUniformResponse>> editUniform({
    required EditUniformRequestModel request,
  }) async {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.put(EndPoints.editUniform, body: request.toJson());
        return EditUniformResponse.fromJson(response);
      },
    );
  }

  @override
  Future<Either<Failure, AddUniformResponseModel>> addUniform({
    required AddUniformRequestModel request,
  }) async {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.post(EndPoints.addUniform, body: request.toJson());
        return AddUniformResponseModel.fromJson(response);
      },
    );
  }

  @override
  Future<Either<Failure, List<StudentCourseDegree>>> studentCourseDegree({
    required int code,
    int? monthNo,
  }) async {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.studentMonthResult,
          queryParameters: {"Code": code, "MonthNo": monthNo},
        );

        final String dataString = response['Data'];
        return StudentCourseDegree.listFromDataString(dataString);
      },
    );
  }

  @override
  Future<Either<Failure, GetPermissionsMobile>> getPermissions({required int code}) async {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.getPermissionsMobile,
          queryParameters: {"Code": code},
        );

        return GetPermissionsMobile.fromJson(response);
      },
    );
  }

  @override
  Future<Either<Failure, GetUniformDataResponse>> getUniforms({required int code, int? id}) async {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.getUniform,
          queryParameters: {"Code": code, "id": id},
        );
        return GetUniformDataResponse.fromJson(response);
      },
    );
  }

  @override
  Future<Either<Failure, List<TeacherLevelModel>>> teacherLevel({required int stageCode}) async {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.teacherLevel,
          queryParameters: {"stagecode": stageCode},
        );

        return TeacherLevelModel.fromApiResponse(response);
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
