import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/error/failures.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import 'package:my_template/features/class/data/model/class_absent_model.dart';
import 'package:my_template/features/class/data/model/class_models.dart';
import 'package:my_template/features/class/data/model/get_T_home_work_model.dart';
import 'package:my_template/features/class/data/model/home_work_model.dart';
import 'package:my_template/features/class/data/model/student_class_data_model.dart';
import 'package:my_template/features/class/data/model/student_courses_model.dart';
import 'package:my_template/features/home/data/models/add_class_absent_request_model.dart';
import 'package:my_template/features/home/data/models/add_class_absent_response_model.dart';
import 'package:my_template/features/home/data/models/class_hW_del_model.dart';

abstract interface class ClassRepo {
  Future<Either<Failure, List<HomeWorkModel>>> getHomeWork({
    required int code,
    required String hwDate,
  });
  Future<Either<Failure, List<THomeWorkItem>>> getTeacherHomeWork({
    required int code,
    required String hwDate,
  });
  Future<Either<Failure, List<StudentCoursesModel>>> getStudentCourses({required int level});

  Future<Either<Failure, GetStudentClassData>> studentClasses({required int ClassCode});
  Future<Either<Failure, List<ClassAbsentModel>>> classAbsent({
    required int classCode,
    required String HwDate,
  });

  Future<Either<Failure, String>> updateClassAbsent({
    required int studentCode,
    required int absentType,
    required String notes,
  });
  Future<Either<Failure, AddClassAbsentResponseModel>> editClassAbsent({
    required AddClassAbsentRequestModel request,
  });
  Future<Either<Failure, ClassHWDelModel>> deleteClassAbsent({
    required int classCode,
    required String HWDATE,
  });
  Future<Either<Failure, ClassHWDelModel>> deleteStudentAbsent({
    required int classCode,
    required String HWDATE,
    required int studentCode,
  });
  final List<StudentClassModel> _studentClasses = const [
    StudentClassModel(
      id: '1',
      className: 'الرياضيات',
      teacherName: 'أ. أحمد محمد',
      room: 'القاعة ١٠١',
      time: '٨:٠٠ ص - ٩:٣٠ ص',
      color: Colors.blue,
      icon: Icons.calculate,
    ),
    StudentClassModel(
      id: '2',
      className: 'اللغة العربية',
      teacherName: 'أ. فاطمة علي',
      room: 'القاعة ٢٠٣',
      time: '١٠:٠٠ ص - ١١:٣٠ ص',
      color: Colors.green,
      icon: Icons.menu_book,
    ),
    StudentClassModel(
      id: '3',
      className: 'العلوم',
      teacherName: 'أ. خالد إبراهيم',
      room: 'المعمل ٣٠١',
      time: '١٢:٠٠ م - ١:٣٠ م',
      color: Colors.orange,
      icon: Icons.science,
    ),
  ];

  final List<TeacherClassModel> _teacherClasses = const [
    TeacherClassModel(
      id: '1',
      className: 'الصف العاشر - الرياضيات',
      studentCount: 32,
      schedule: 'السبت، الإثنين، الأربعاء',
      time: '٨:٠٠ ص - ٩:٣٠ ص',
      room: 'القاعة ١٠١',
      progress: 0.75,
      assignments: 3,
    ),
    TeacherClassModel(
      id: '2',
      className: 'الصف التاسع - الرياضيات',
      studentCount: 28,
      schedule: 'الأحد، الثلاثاء، الخميس',
      time: '١٠:٠٠ ص - ١١:٣٠ ص',
      room: 'القاعة ٢٠٣',
      progress: 0.60,
      assignments: 2,
    ),
  ];

  final List<AdminClassModel> _adminClasses = const [
    AdminClassModel(
      id: '1',
      name: 'الصف الأول - أ',
      grade: 'الأول',
      section: 'أ',
      capacity: 30,
      currentStudents: 25,
      teacher: 'أحمد محمد',
      room: '101',
      schedule: 'من الأحد إلى الخميس - 7:30 صباحاً',
    ),
    AdminClassModel(
      id: '2',
      name: 'الصف الأول - ب',
      grade: 'الأول',
      section: 'ب',
      capacity: 30,
      currentStudents: 28,
      teacher: 'فاطمة علي',
      room: '102',
      schedule: 'من الأحد إلى الخميس - 7:30 صباحاً',
    ),
  ];

  Future<List<StudentClassModel>> getStudentClasses() async {
    return _studentClasses;
  }

  Future<List<TeacherClassModel>> getTeacherClasses() async {
    return _teacherClasses;
  }

  Future<List<AdminClassModel>> getAdminClasses() async {
    return _adminClasses;
  }

  Future<List<StudentClassModel>> getParentStudentClasses() async {
    return _studentClasses;
  }
}

class ClassRepoImpl extends ClassRepo {
  final ApiConsumer apiConsumer;
  ClassRepoImpl(this.apiConsumer);
  @override
  Future<Either<Failure, List<HomeWorkModel>>> getHomeWork({
    required int code,
    required String hwDate,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.getHomeWork,
          queryParameters: {"Code": code, "HWDate": hwDate},
        );
        final dynamic rawData = response['Data'];
        if (rawData == null || rawData == "null" || rawData == "" || rawData == "[]") {
          return [];
        }

        List<dynamic> list;
        if (rawData is String) {
          list = jsonDecode(rawData);
        } else {
          list = rawData;
        }

        return list.map((e) => HomeWorkModel.fromJson(e)).toList();
      },
    );
  }

  @override
  Future<Either<Failure, List<StudentCoursesModel>>> getStudentCourses({required int level}) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.studentCourses,
          queryParameters: {"Level": level},
        );
        final rawData = response['Data'];
        if (rawData == null || rawData == "null" || rawData == "" || rawData == "[]") {
          return <StudentCoursesModel>[];
        }
        List<dynamic> decoded = [];
        if (rawData is String) {
          try {
            decoded = jsonDecode(rawData);
          } catch (_) {
            return <StudentCoursesModel>[];
          }
        } else if (rawData is List) {
          decoded = rawData;
        }
        return decoded.map((e) => StudentCoursesModel.fromJson(e)).toList();
      },
    );
  }

  Future<Either<Failure, List<THomeWorkItem>>> getTeacherHomeWork({
    required int code,
    required String hwDate,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.getTHomeWork,
          queryParameters: {"Classcode": code, "HWDate": hwDate},
        );

        final model = GetTHomeWorkModel.fromJson(response);
        return model.data;
      },
    );
  }

  Future<Either<Failure, GetStudentClassData>> studentClasses({required int ClassCode}) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.studentClass,
          queryParameters: {"classcode": ClassCode},
        );
        return GetStudentClassData.fromJson(response);
      },
    );
  }

  Future<Either<Failure, List<ClassAbsentModel>>> classAbsent({
    required int classCode,
    required String HwDate,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.classabsent,
          queryParameters: {"Classcode": classCode, "ABSENTDATE": HwDate},
        );
        return ClassAbsentModel.listFromJson(response['Data']);
      },
    );
  }

  Future<Either<Failure, AddClassAbsentResponseModel>> editClassAbsent({
    required AddClassAbsentRequestModel request,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.put(EndPoints.editClassabsent, body: request.toJson());
        return AddClassAbsentResponseModel.fromJson(response);
      },
    );
  }

  Future<Either<Failure, ClassHWDelModel>> deleteClassAbsent({
    required int classCode,
    required String HWDATE,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.delete(
          EndPoints.deleteClassabsent,
          body: {"classcodes": classCode, "ABSENTDATE": HWDATE},
        );
        return ClassHWDelModel.fromJson(response);
      },
    );
  }

  Future<Either<Failure, ClassHWDelModel>> deleteStudentAbsent({
    required int classCode,
    required String HWDATE,
    required int studentCode,
  }) {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.delete(
          EndPoints.studentabsentDel,
          body: {"classcodes": classCode, "ABSENTDATE": HWDATE, "STUDENT_CODE": studentCode},
        );
        return ClassHWDelModel.fromJson(response);
      },
    );
  }

  @override
  Future<Either<Failure, String>> updateClassAbsent({
    required int studentCode,
    required int absentType,
    required String notes,
  }) {
    return Future.value(const Right("Updated successfully"));
  }
}
