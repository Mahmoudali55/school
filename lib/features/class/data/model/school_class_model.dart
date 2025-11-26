// lib/features/classes/data/models/school_class_model.dart
class SchoolClass {
  final String id;
  final String name;
  final String grade;
  final String section;
  final int capacity;
  final int currentStudents;
  final String teacher;
  final String room;
  final String schedule;

  SchoolClass({
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
}

class Student {
  final String id;
  final String name;
  final String academicId;
  final String phone;
  final String parentName;

  Student(this.id, this.name, this.academicId, this.phone, this.parentName);
}
