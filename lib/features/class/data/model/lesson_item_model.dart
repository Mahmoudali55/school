import 'package:equatable/equatable.dart';

class LessonItemModel extends Equatable {
  final int id;
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
  final String courseName;
  final int courseCode;

  const LessonItemModel({
    required this.id,
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
    required this.courseName,
    required this.courseCode,
  });

  factory LessonItemModel.fromJson(Map<String, dynamic> json) {
    return LessonItemModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      sectionCode:
          int.tryParse(
            (json['SectionCode'] ?? json['SECTION_CODE'] ?? json['Section_Code'])?.toString() ??
                '0',
          ) ??
          0,
      stageCode:
          int.tryParse(
            (json['StageCode'] ?? json['Stage_Code'] ?? json['STAGE_CODE'])?.toString() ?? '0',
          ) ??
          0,
      levelCode:
          int.tryParse(
            (json['LevelCode'] ?? json['LEVEL_CODE'] ?? json['Level_Code'])?.toString() ?? '0',
          ) ??
          0,
      classCode:
          int.tryParse(
            (json['ClassCode'] ?? json['CLASS_CODE'] ?? json['Class_Code'])?.toString() ?? '0',
          ) ??
          0,
      lesson: (json['lesson'] ?? json['LESSON'] ?? json['Lesson'])?.toString() ?? '',
      lessonPath:
          (json['lesson_path'] ?? json['LESSON_PATH'] ?? json['LessonPath'] ?? json['lessonPath'])
              ?.toString(),
      lessonDate:
          (json['lessonDate'] ?? json['LESSON_DATE'] ?? json['LessonDate'] ?? json['lesson_date'])
              ?.toString() ??
          '',
      notes:
          (json['Notes'] ?? json['NOTES'] ?? json['notes'] ?? json['Note'] ?? json['NOTE'])
              ?.toString() ??
          '',
      teacherCode:
          int.tryParse(
            (json['Teacher_code'] ??
                        json['TEACHER_CODE'] ??
                        json['TeacherCode'] ??
                        json['Teacher_Code'])
                    ?.toString() ??
                '0',
          ) ??
          0,
      className:
          (json['CLASS_NAME'] ?? json['ClassName'] ?? json['class_name'] ?? json['CLASS_NAME_AR'])
              ?.toString() ??
          '',
      levelName:
          (json['LEVEL_NAME'] ?? json['LevelName'] ?? json['level_name'] ?? json['LEVEL_NAME_AR'])
              ?.toString() ??
          '',
      courseName:
          (json['Coursename'] ??
                  json['COURSE_Name'] ??
                  json['COURSE_NAME'] ??
                  json['COURSE_NAME_AR'] ??
                  json['CourseName'] ??
                  json['course_name'])
              ?.toString() ??
          '',
      courseCode:
          int.tryParse(
            (json['CourseCode'] ??
                        json['COURSE_CODE'] ??
                        json['Course_code'] ??
                        json['COURSE_code'] ??
                        json['Course_Code'] ??
                        json['course_code'] ??
                        json['SubjectCode'] ??
                        json['SUBJECT_CODE'] ??
                        json['subject_code'] ??
                        json['Subject_Code'])
                    ?.toString() ??
                '0',
          ) ??
          0,
    );
  }

  @override
  List<Object?> get props => [
    id,
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
    courseName,
    courseCode,
  ];
}
