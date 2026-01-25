import 'package:equatable/equatable.dart';

class AddPermissionsMobile extends Equatable {
  final int studentCode;
  final int parentCode;
  final String reason;
  final String notes;
  final String requestDate;

  const AddPermissionsMobile({
    required this.studentCode,
    required this.parentCode,
    required this.reason,
    required this.notes,
    required this.requestDate,
  });

  factory AddPermissionsMobile.fromJson(Map<String, dynamic> json) {
    return AddPermissionsMobile(
      studentCode: json['StudentCode'] as int,
      parentCode: json['ParentCode'] as int,
      reason: json['Reason'] as String,
      notes: json['Notes'] as String,
      requestDate: json['RequestDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StudentCode': studentCode,
      'ParentCode': parentCode,
      'Reason': reason,
      'Notes': notes,
      'RequestDate': requestDate,
    };
  }

  @override
  List<Object?> get props => [studentCode, parentCode, reason, notes, requestDate];
}
