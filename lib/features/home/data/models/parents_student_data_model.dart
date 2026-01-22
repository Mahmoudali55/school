import 'dart:convert';

import 'package:equatable/equatable.dart';

class ParentsStudentData extends Equatable {
  final int studentCode;
  final String studentName;

  const ParentsStudentData({required this.studentCode, required this.studentName});

  /// تحويل JSON Map إلى Object
  factory ParentsStudentData.fromJson(Map<String, dynamic> json) {
    return ParentsStudentData(
      studentCode: json['STUDENT_CODE'] as int,
      studentName: json['S_NAME'] as String,
    );
  }

  /// تحويل Object إلى JSON
  Map<String, dynamic> toJson() {
    return {'STUDENT_CODE': studentCode, 'S_NAME': studentName};
  }

  /// لتحويل قيمة Data (String) إلى List<ParentsStudentData>
  static List<ParentsStudentData> listFromDataString(String data) {
    final List decoded = jsonDecode(data);
    return decoded.map((e) => ParentsStudentData.fromJson(e)).toList();
  }

  @override
  List<Object?> get props => [studentCode, studentName];
}
