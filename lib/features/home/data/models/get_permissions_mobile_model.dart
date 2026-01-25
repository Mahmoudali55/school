import 'dart:convert';

import 'package:equatable/equatable.dart';

class GetPermissionsMobile extends Equatable {
  final List<PermissionItem> data;

  const GetPermissionsMobile({required this.data});

  factory GetPermissionsMobile.fromJson(Map<String, dynamic> json) {
    final decodedList = jsonDecode(json['Data']) as List;

    return GetPermissionsMobile(data: decodedList.map((e) => PermissionItem.fromJson(e)).toList());
  }

  @override
  List<Object?> get props => [data];
}

class PermissionItem extends Equatable {
  final int id;
  final int studentCode;
  final int parentCode;
  final String reason;
  final String requestDate;
  final String notes;
  final String studentName;

  const PermissionItem({
    required this.id,
    required this.studentCode,
    required this.parentCode,
    required this.reason,
    required this.requestDate,
    required this.notes,
    required this.studentName,
  });

  factory PermissionItem.fromJson(Map<String, dynamic> json) {
    return PermissionItem(
      id: json['id'],
      studentCode: json['StudentCode'],
      parentCode: json['ParentCode'],
      reason: json['Reason'],
      requestDate: json['RequestDate'],
      notes: json['Notes'],
      studentName: json['s_name'],
    );
  }

  @override
  List<Object?> get props => [id, studentCode, parentCode, reason, requestDate, notes, studentName];
}
