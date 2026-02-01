import 'package:equatable/equatable.dart';

class HomeworkDetailsModel extends Equatable {
  final int levelCode;
  final int classCode;
  final int courseCode;
  final String hwDate;
  final String hw;
  final String? notes;

  const HomeworkDetailsModel({
    required this.levelCode,
    required this.classCode,
    required this.courseCode,
    required this.hwDate,
    required this.hw,
    this.notes,
  });

  factory HomeworkDetailsModel.fromJson(Map<String, dynamic> json) {
    return HomeworkDetailsModel(
      levelCode: json['LEVELCODE'] as int,
      classCode: json['classcode'] as int,
      courseCode: json['COURSE_CODE'] as int,
      hwDate: json['HWDATE'] as String,
      hw: json['HW'] as String,
      notes: json['NOTES'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LEVELCODE': levelCode,
      'classcode': classCode,
      'COURSE_CODE': courseCode,
      'HWDATE': hwDate,
      'HW': hw,
      'NOTES': notes,
    };
  }

  @override
  List<Object?> get props => [levelCode, classCode, courseCode, hwDate, hw, notes];
}
