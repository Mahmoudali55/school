import 'package:equatable/equatable.dart';

class TeacherInfo extends Equatable {
  final String name;
  final String subject;
  final String email;
  final String? avatarUrl;

  const TeacherInfo({
    required this.name,
    required this.subject,
    required this.email,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [name, subject, email, avatarUrl];

  TeacherInfo copyWith({String? name, String? subject, String? email, String? avatarUrl}) {
    return TeacherInfo(
      name: name ?? this.name,
      subject: subject ?? this.subject,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}

class ClassInfo extends Equatable {
  final String id;
  final String className;
  final int studentCount;
  final String schedule;
  final String time;
  final String room;
  final double progress;
  final int assignments;

  const ClassInfo({
    required this.id,
    required this.className,
    required this.studentCount,
    required this.schedule,
    required this.time,
    required this.room,
    required this.progress,
    required this.assignments,
  });

  @override
  List<Object?> get props => [
    id,
    className,
    studentCount,
    schedule,
    time,
    room,
    progress,
    assignments,
  ];

  ClassInfo copyWith({
    String? id,
    String? className,
    int? studentCount,
    String? schedule,
    String? time,
    String? room,
    double? progress,
    int? assignments,
  }) {
    return ClassInfo(
      id: id ?? this.id,
      className: className ?? this.className,
      studentCount: studentCount ?? this.studentCount,
      schedule: schedule ?? this.schedule,
      time: time ?? this.time,
      room: room ?? this.room,
      progress: progress ?? this.progress,
      assignments: assignments ?? this.assignments,
    );
  }
}

class ClassStats extends Equatable {
  final int totalStudents;
  final int totalAssignments;
  final int totalLessons;
  final double attendanceRate;

  const ClassStats({
    required this.totalStudents,
    required this.totalAssignments,
    required this.totalLessons,
    required this.attendanceRate,
  });

  @override
  List<Object?> get props => [totalStudents, totalAssignments, totalLessons, attendanceRate];

  ClassStats copyWith({
    int? totalStudents,
    int? totalAssignments,
    int? totalLessons,
    double? attendanceRate,
  }) {
    return ClassStats(
      totalStudents: totalStudents ?? this.totalStudents,
      totalAssignments: totalAssignments ?? this.totalAssignments,
      totalLessons: totalLessons ?? this.totalLessons,
      attendanceRate: attendanceRate ?? this.attendanceRate,
    );
  }
}
