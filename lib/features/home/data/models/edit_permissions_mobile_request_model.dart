import 'package:equatable/equatable.dart';

class EditPermissionsMobileRequest extends Equatable {
  final int id;
  final int studentCode;
  final int parentCode;
  final String reason;
  final String notes;
  final String requestDate;

  const EditPermissionsMobileRequest({
    required this.id,
    required this.studentCode,
    required this.parentCode,
    required this.reason,
    required this.notes,
    required this.requestDate,
  });

  factory EditPermissionsMobileRequest.fromJson(Map<String, dynamic> json) {
    return EditPermissionsMobileRequest(
      id: json['id'] as int,
      studentCode: json['StudentCode'] as int,
      parentCode: json['ParentCode'] as int,
      reason: json['Reason'] as String,
      notes: json['Notes'] as String,
      requestDate: json['RequestDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'StudentCode': studentCode,
      'ParentCode': parentCode,
      'Reason': reason,
      'Notes': notes,
      'RequestDate': requestDate,
    };
  }

  @override
  List<Object?> get props => [id, studentCode, parentCode, reason, notes, requestDate];
}
