import 'dart:convert';

import 'package:equatable/equatable.dart';

class StudentBalanceModel extends Equatable {
  final int parentCode;
  final int studentCode;
  final double balance;
  final String studentName;

  const StudentBalanceModel({
    required this.parentCode,
    required this.studentCode,
    required this.balance,
    required this.studentName,
  });

  factory StudentBalanceModel.fromJson(Map<String, dynamic> json) {
    return StudentBalanceModel(
      parentCode: json['PARENT_CODE'] as int? ?? 0,
      studentCode: json['STUDENT_CODE'] as int? ?? 0,
      balance: (json['BALANCE'] as num?)?.toDouble() ?? 0.0,
      studentName: json['s_name'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PARENT_CODE': parentCode,
      'STUDENT_CODE': studentCode,
      'BALANCE': balance,
      's_name': studentName,
    };
  }

  /// لتحويل Data string من API إلى List<StudentBalanceModel>
  static List<StudentBalanceModel> listFromDataString(String data) {
    if (data.isEmpty || data == "[]") return [];
    final List decoded = jsonDecode(data);
    return decoded.map((e) => StudentBalanceModel.fromJson(e)).toList();
  }

  @override
  List<Object?> get props => [parentCode, studentCode, balance, studentName];
}
