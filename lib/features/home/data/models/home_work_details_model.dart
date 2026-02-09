import 'package:equatable/equatable.dart';

class HomeworkDetailsModel extends Equatable {
  final int levelCode;
  final int classCode;
  final int courseCode;
  final String hwDate;
  final String hw;
  final String? notes;
  final String? hW_path;

  const HomeworkDetailsModel({
    required this.levelCode,
    required this.classCode,
    required this.courseCode,
    required this.hwDate,
    required this.hw,
    this.hW_path,
    this.notes,
  });

  factory HomeworkDetailsModel.fromJson(Map<String, dynamic> json) {
    return HomeworkDetailsModel(
      levelCode: int.tryParse(json['LEVELCODE']?.toString() ?? '0') ?? 0,
      classCode: int.tryParse(json['classcode']?.toString() ?? '0') ?? 0,
      courseCode:
          int.tryParse(
            (json['COURSE_CODE'] ??
                        json['CourseCode'] ??
                        json['SubjectCode'] ??
                        json['SUBJECT_CODE'] ??
                        json['subject_code'] ??
                        json['Course_Code'] ??
                        json['course_code'])
                    ?.toString() ??
                '0',
          ) ??
          0,
      hwDate: json['HWDATE']?.toString() ?? '',
      hw: json['HW']?.toString() ?? '',
      notes: json['NOTES']?.toString(),
      hW_path: json['HW_path']?.toString(),
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
      'HW_path': hW_path,
    };
  }

  @override
  List<Object?> get props => [levelCode, classCode, courseCode, hwDate, hw, notes, hW_path];
}
