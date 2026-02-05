import 'package:equatable/equatable.dart';

class LessonItemModel extends Equatable {
  final int sectionCode;
  final int stageCode;
  final int levelCode;
  final int classCode;
  final String lesson;
  final String? lessonPath;
  final String lessonDate;
  final String notes;
  final int teacherCode;
  final String className;
  final String levelName;

  const LessonItemModel({
    required this.sectionCode,
    required this.stageCode,
    required this.levelCode,
    required this.classCode,
    required this.lesson,
    this.lessonPath,
    required this.lessonDate,
    required this.notes,
    required this.teacherCode,
    required this.className,
    required this.levelName,
  });

  factory LessonItemModel.fromJson(Map<String, dynamic> json) {
    return LessonItemModel(
      sectionCode: json['SectionCode'] ?? 0,
      stageCode: json['StageCode'] ?? 0,
      levelCode: json['LevelCode'] ?? 0,
      classCode: json['ClassCode'] ?? 0,
      lesson: json['lesson'] ?? '',
      lessonPath: json['lesson_path'],
      lessonDate: json['lessonDate'] ?? '',
      notes: json['Notes'] ?? '',
      teacherCode: json['Teacher_code'] ?? 0,
      className: json['CLASS_NAME'] ?? '',
      levelName: json['LEVEL_NAME'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
    sectionCode,
    stageCode,
    levelCode,
    classCode,
    lesson,
    lessonPath,
    lessonDate,
    notes,
    teacherCode,
    className,
    levelName,
  ];
}
