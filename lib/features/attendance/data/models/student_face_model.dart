import 'package:hive/hive.dart';

part 'student_face_model.g.dart';

@HiveType(typeId: 10)
class StudentFaceModel {
  @HiveField(0)
  final String studentId;

  @HiveField(1)
  final String studentName;

  @HiveField(2)
  final String faceImagePath;

  @HiveField(3)
  final DateTime registrationDate;

  @HiveField(4)
  final String classId;

  @HiveField(5)
  final Map<String, dynamic>? faceMetadata;

  StudentFaceModel({
    required this.studentId,
    required this.studentName,
    required this.faceImagePath,
    required this.registrationDate,
    required this.classId,
    this.faceMetadata,
  });

  factory StudentFaceModel.fromJson(Map<String, dynamic> json) {
    return StudentFaceModel(
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      faceImagePath: json['faceImagePath'] as String,
      registrationDate: DateTime.parse(json['registrationDate'] as String),
      classId: json['classId'] as String,
      faceMetadata: json['faceMetadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'faceImagePath': faceImagePath,
      'registrationDate': registrationDate.toIso8601String(),
      'classId': classId,
      'faceMetadata': faceMetadata,
    };
  }

  StudentFaceModel copyWith({
    String? studentId,
    String? studentName,
    String? faceImagePath,
    DateTime? registrationDate,
    String? classId,
    Map<String, dynamic>? faceMetadata,
  }) {
    return StudentFaceModel(
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      faceImagePath: faceImagePath ?? this.faceImagePath,
      registrationDate: registrationDate ?? this.registrationDate,
      classId: classId ?? this.classId,
      faceMetadata: faceMetadata ?? this.faceMetadata,
    );
  }
}
