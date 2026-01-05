import 'package:flutter/material.dart';

class ProfileModel {
  final String name;
  final String email;
  final String? grade;
  final String? section;
  final double? attendanceRate;
  final double? averageGrade;
  final String? profileImage;
  final String? phone;
  final String? address;
  final String? idNumber;

  ProfileModel({
    required this.name,
    required this.email,
    this.grade,
    this.section,
    this.attendanceRate,
    this.averageGrade,
    this.profileImage,
    this.phone,
    this.address,
    this.idNumber,
  });

  ProfileModel copyWith({
    String? name,
    String? email,
    String? grade,
    String? section,
    double? attendanceRate,
    double? averageGrade,
    String? profileImage,
    String? phone,
    String? address,
    String? idNumber,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      grade: grade ?? this.grade,
      section: section ?? this.section,
      attendanceRate: attendanceRate ?? this.attendanceRate,
      averageGrade: averageGrade ?? this.averageGrade,
      profileImage: profileImage ?? this.profileImage,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      idNumber: idNumber ?? this.idNumber,
    );
  }
}

class ProfileActivity {
  final String title;
  final String time;
  final IconData icon;
  final Color color;

  ProfileActivity({
    required this.title,
    required this.time,
    required this.icon,
    required this.color,
  });
}

class Achievement {
  final String title;
  final String desc;
  final IconData icon;
  final Color color;

  Achievement({required this.title, required this.desc, required this.icon, required this.color});
}
