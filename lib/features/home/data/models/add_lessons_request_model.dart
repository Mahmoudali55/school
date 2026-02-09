import 'package:equatable/equatable.dart';

class AddLessonsRequestModel extends Equatable {
  final String id;
  final int sectionCode;
  final int stageCode;
  final int levelCode;
  final int classCode;
  final int courseCode;
  final String lesson;
  final String lessonPath;
  final String lessonDate;
  final int teacherCode;
  final String notes;
  final String? username; // اختياري

  const AddLessonsRequestModel({
    required this.id,
    required this.sectionCode,
    required this.stageCode,
    required this.levelCode,
    required this.classCode,
    required this.courseCode,
    required this.lesson,
    required this.lessonPath,
    required this.lessonDate,
    required this.teacherCode,
    required this.notes,
    this.username,
  });

  factory AddLessonsRequestModel.fromJson(Map<String, dynamic> json) {
    return AddLessonsRequestModel(
      id: json['id'] ?? '',
      sectionCode: json['SectionCode'] ?? 0,
      stageCode: json['StageCode'] ?? 0,
      levelCode: json['LevelCode'] ?? 0,
      classCode: json['ClassCode'] ?? 0,
      courseCode: json['CourseCode'] ?? 0,
      lesson: json['lesson'] ?? '',
      lessonPath: json['lesson_path'] ?? '',
      lessonDate: json['lessonDate'] ?? '',
      teacherCode: json['Teacher_code'] ?? 0,
      notes: json['NOTES'] ?? '',
      username: json['username'], // يمكن أن يكون null
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'SectionCode': sectionCode,
      'StageCode': stageCode,
      'LevelCode': levelCode,
      'ClassCode': classCode,
      'CourseCode': courseCode,
      'lesson': lesson,
      'lesson_path': lessonPath,
      'lessonDate': lessonDate,
      'Teacher_code': teacherCode,
      'NOTES': notes,
    };

    return data;
  }

  AddLessonsRequestModel copyWith({
    String? id,
    int? sectionCode,
    int? stageCode,
    int? levelCode,
    int? classCode,
    int? courseCode,
    String? lesson,
    String? lessonPath,
    String? lessonDate,
    int? teacherCode,
    String? notes,
    String? username,
  }) {
    return AddLessonsRequestModel(
      id: id ?? this.id,
      sectionCode: sectionCode ?? this.sectionCode,
      stageCode: stageCode ?? this.stageCode,
      levelCode: levelCode ?? this.levelCode,
      classCode: classCode ?? this.classCode,
      courseCode: courseCode ?? this.courseCode,
      lesson: lesson ?? this.lesson,
      lessonPath: lessonPath ?? this.lessonPath,
      lessonDate: lessonDate ?? this.lessonDate,
      teacherCode: teacherCode ?? this.teacherCode,
      notes: notes ?? this.notes,
      username: username ?? this.username,
    );
  }

  @override
  List<Object?> get props => [
    id,
    sectionCode,
    stageCode,
    levelCode,
    classCode,
    courseCode,
    lesson,
    lessonPath,
    lessonDate,
    teacherCode,
    notes,
    username,
  ];
}
