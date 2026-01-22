import 'dart:convert';

import 'package:equatable/equatable.dart';

class StudentAbsentCount extends Equatable {
  final int absentCount;

  const StudentAbsentCount({required this.absentCount});

  factory StudentAbsentCount.fromJson(Map<String, dynamic> json) {
    return StudentAbsentCount(absentCount: json['Absentcount'] as int);
  }

  Map<String, dynamic> toJson() {
    return {'Absentcount': absentCount};
  }

  static List<StudentAbsentCount> listFromDataString(String data) {
    final List decoded = jsonDecode(data);
    return decoded.map((e) => StudentAbsentCount.fromJson(e)).toList();
  }

  @override
  List<Object?> get props => [absentCount];
}
