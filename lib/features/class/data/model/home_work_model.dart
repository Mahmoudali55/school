import 'package:equatable/equatable.dart';

class HomeWorkModel extends Equatable {
  final String deltaConfig;
  final int levelCode;
  final int classCode;
  final String hwDate;
  final int courseCode;
  final String hw;
  final String notes;
  final int? schoolCode;
  final String courseName;

  const HomeWorkModel({
    required this.deltaConfig,
    required this.levelCode,
    required this.classCode,
    required this.hwDate,
    required this.courseCode,
    required this.hw,
    required this.notes,
    this.schoolCode,
    required this.courseName,
  });

  factory HomeWorkModel.fromJson(Map<String, dynamic> json) {
    return HomeWorkModel(
      deltaConfig: json['DELTACONFIG']?.toString() ?? '',
      levelCode: int.tryParse(json['LEVEL_CODE']?.toString() ?? '0') ?? 0,
      classCode: int.tryParse(json['CLASS_CODE']?.toString() ?? '0') ?? 0,
      hwDate: json['HW_DATE']?.toString() ?? '',
      courseCode: int.tryParse(json['COURSE_CODE']?.toString() ?? '0') ?? 0,
      hw: json['HW']?.toString() ?? '',
      notes: json['NOTES']?.toString() ?? '',
      schoolCode: int.tryParse(json['SCHOOL_CODE']?.toString() ?? ''),
      courseName: json['COURSE_NAME']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [
    deltaConfig,
    levelCode,
    classCode,
    hwDate,
    courseCode,
    hw,
    notes,
    schoolCode,
    courseName,
  ];
}
