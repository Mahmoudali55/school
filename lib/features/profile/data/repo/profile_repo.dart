import 'package:flutter/material.dart';
import 'package:my_template/features/profile/data/model/profile_model.dart';

class ProfileRepo {
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

  Future<ProfileModel> getParentProfile() async {
    return ProfileModel(
      name: 'أحمد السعيد',
      email: 'ahmed@email.com',
      phone: '+966 50 123 4567',
      address: 'الرياض - العليا',
      idNumber: '1234567890',
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
