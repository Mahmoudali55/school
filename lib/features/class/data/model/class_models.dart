import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ClassModel extends Equatable {
  const ClassModel();

  @override
  List<Object?> get props => [];
}

class StudentClassModel extends ClassModel {
  final String id;
  final String className;
  final String teacherName;
  final String room;
  final String time;
  final Color color;
  final IconData icon;

  const StudentClassModel({
    required this.id,
    required this.className,
    required this.teacherName,
    required this.room,
    required this.time,
    required this.color,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, className, teacherName, room, time, color, icon];
}

class AdminClassModel extends ClassModel {
  final String id;
  final String name;
  final String grade;
  final String section;
  final int capacity;
  final int currentStudents;
  final String teacher;
  final String room;
  final String schedule;

  const AdminClassModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.section,
    required this.capacity,
    required this.currentStudents,
    required this.teacher,
    required this.room,
    required this.schedule,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    grade,
    section,
    capacity,
    currentStudents,
    teacher,
    room,
    schedule,
  ];
}

// Reuse TeacherInfo and ClassInfo from existing model if possible, or redefine here for safety
class TeacherClassModel extends ClassModel {
  final String id;
  final String className;
  final int studentCount;
  final String schedule;
  final String time;
  final String room;
  final double progress;
  final int assignments;

  const TeacherClassModel({
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
}
