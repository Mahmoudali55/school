import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:my_template/core/error/failures.dart';
import 'package:my_template/core/network/api_consumer.dart';
import 'package:my_template/core/network/end_points.dart';
import 'package:my_template/features/profile/data/model/parent_profile_model.dart';
import 'package:my_template/features/profile/data/model/profile_model.dart';
import 'package:my_template/features/profile/data/model/student_profile_model.dart';

abstract class ProfileRepo {
  Future<Either<Failure, ParentProfileModel>> getParentProfile({required int code});
  Future<Either<Failure, StudentProfileModel>> StudentProfile({required int code});
  Future<ProfileModel> getStudentProfile() async {
    return ProfileModel(
      name: 'محمد أحمد السعيد',
      email: 'mohammed.ahmed@school.com',
      grade: 'الصف العاشر',
      section: 'القسم العلمي',
      attendanceRate: 95,
      averageGrade: 88.5,
    );
  }

  Future<List<ProfileActivity>> getStudentActivities() async {
    return [
      ProfileActivity(
        title: 'تم تسليم واجب الرياضيات',
        time: 'قبل ساعتين',
        icon: Icons.assignment_turned_in,
        color: Colors.green,
      ),
      ProfileActivity(
        title: 'اختبار الفيزياء',
        time: 'قبل 5 ساعات',
        icon: Icons.quiz,
        color: Colors.blue,
      ),
      ProfileActivity(
        title: 'حضور حصة الكيمياء',
        time: 'أمس',
        icon: Icons.video_library,
        color: Colors.orange,
      ),
    ];
  }

  Future<List<Achievement>> getStudentAchievements() async {
    return [
      Achievement(
        title: 'التميز الأكاديمي',
        desc: 'أعلى درجة في الرياضيات',
        icon: Icons.emoji_events,
        color: Colors.amber,
      ),
      Achievement(
        title: 'الحضور المثالي',
        desc: '100% حضور الشهر',
        icon: Icons.verified_user,
        color: Colors.green,
      ),
    ];
  }
}

class ProfileRepoImpl extends ProfileRepo {
  final ApiConsumer apiConsumer;
  ProfileRepoImpl(this.apiConsumer);
  @override
  Future<Either<Failure, ParentProfileModel>> getParentProfile({required int code}) async {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.getParentProfile,
          queryParameters: {"Code": code},
        );
        if (response['Data'] == null) {
          throw const FormatException("No data found");
        }
        // Data comes as a JSON string inside the 'Data' field
        final List<ParentProfileModel> profiles = ParentProfileModel.fromApi(response['Data']);
        if (profiles.isEmpty) {
          throw const FormatException("Empty profile data");
        }
        return profiles.first;
      },
    );
  }

  @override
  Future<Either<Failure, StudentProfileModel>> StudentProfile({required int code}) async {
    return handleDioRequest(
      request: () async {
        final response = await apiConsumer.get(
          EndPoints.studentProfile,
          queryParameters: {"Code": code},
        );
        final dynamic rawData = response['Data'];
        if (rawData == null) {
          throw const FormatException("No data found");
        }

        List<dynamic> list;
        if (rawData is String) {
          list = jsonDecode(rawData);
        } else if (rawData is List) {
          list = rawData;
        } else {
          throw const FormatException("Invalid data format");
        }

        if (list.isEmpty) {
          throw const FormatException("Empty profile data");
        }

        // The API returns a list, but we expect a single student profile
        return StudentProfileModel.fromJson(list.first);
      },
    );
  }
}
