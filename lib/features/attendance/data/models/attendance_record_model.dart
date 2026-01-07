import 'package:hive/hive.dart';

part 'attendance_record_model.g.dart';

@HiveType(typeId: 12)
enum AttendanceStatus {
  @HiveField(0)
  present,
  @HiveField(1)
  absent,
  @HiveField(2)
  late,
  @HiveField(3)
  excused,
}

@HiveType(typeId: 13)
enum RecognitionMethod {
  @HiveField(0)
  faceRecognition,
  @HiveField(1)
  manual,
  @HiveField(2)
  qrCode,
}

@HiveType(typeId: 11)
class AttendanceRecordModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String studentId;

  @HiveField(2)
  final String studentName;

  @HiveField(3)
  final String classId;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final AttendanceStatus status;

  @HiveField(6)
  final RecognitionMethod recognitionMethod;

  @HiveField(7)
  final double? confidenceScore;

  @HiveField(8)
  final DateTime? checkInTime;

  @HiveField(9)
  final String? notes;

  @HiveField(10)
  final String? teacherId;

  AttendanceRecordModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.classId,
    required this.date,
    required this.status,
    required this.recognitionMethod,
    this.confidenceScore,
    this.checkInTime,
    this.notes,
    this.teacherId,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      studentName: json['studentName'] as String,
      classId: json['classId'] as String,
      date: DateTime.parse(json['date'] as String),
      status: AttendanceStatus.values.firstWhere(
        (e) => e.toString() == 'AttendanceStatus.${json['status']}',
        orElse: () => AttendanceStatus.absent,
      ),
      recognitionMethod: RecognitionMethod.values.firstWhere(
        (e) => e.toString() == 'RecognitionMethod.${json['recognitionMethod']}',
        orElse: () => RecognitionMethod.manual,
      ),
      confidenceScore: json['confidenceScore'] as double?,
      checkInTime: json['checkInTime'] != null
          ? DateTime.parse(json['checkInTime'] as String)
          : null,
      notes: json['notes'] as String?,
      teacherId: json['teacherId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'classId': classId,
      'date': date.toIso8601String(),
      'status': status.toString().split('.').last,
      'recognitionMethod': recognitionMethod.toString().split('.').last,
      'confidenceScore': confidenceScore,
      'checkInTime': checkInTime?.toIso8601String(),
      'notes': notes,
      'teacherId': teacherId,
    };
  }

  AttendanceRecordModel copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? classId,
    DateTime? date,
    AttendanceStatus? status,
    RecognitionMethod? recognitionMethod,
    double? confidenceScore,
    DateTime? checkInTime,
    String? notes,
    String? teacherId,
  }) {
    return AttendanceRecordModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      classId: classId ?? this.classId,
      date: date ?? this.date,
      status: status ?? this.status,
      recognitionMethod: recognitionMethod ?? this.recognitionMethod,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      checkInTime: checkInTime ?? this.checkInTime,
      notes: notes ?? this.notes,
      teacherId: teacherId ?? this.teacherId,
    );
  }
}
