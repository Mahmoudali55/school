import 'dart:convert';

import 'package:equatable/equatable.dart';

class ParentProfileModel extends Equatable {
  final int parentCode;
  final String parentNameAr;
  final String parentNameEng;
  final String fatherNameAr;
  final String fatherNameEng;
  final int? prioritySystem;
  final String idNo;
  final int? paymentAuthority;
  final double accountNo;
  final int? employeeChildren;
  final String? mobileNo;
  final int? nationCode;
  final String priorityName;
  final String? authName;
  final String? email;
  final String password;

  const ParentProfileModel({
    required this.parentCode,
    required this.parentNameAr,
    required this.parentNameEng,
    required this.fatherNameAr,
    required this.fatherNameEng,
    required this.prioritySystem,
    required this.idNo,
    required this.paymentAuthority,
    required this.accountNo,
    required this.employeeChildren,
    required this.mobileNo,
    required this.nationCode,
    required this.priorityName,
    required this.authName,
    required this.email,
    required this.password,
  });

  /// 👇 Parsing object واحد
  factory ParentProfileModel.fromJson(Map<String, dynamic> json) {
    return ParentProfileModel(
      parentCode: json['PARENT_CODE'] ?? 0,
      parentNameAr: json['P_NAME_AR'] ?? '',
      parentNameEng: json['P_NAME_ENG'] ?? '',
      fatherNameAr: json['F_NAME_AR'] ?? '',
      fatherNameEng: json['F_NAME_ENG'] ?? '',
      prioritySystem: json['PRIORITY_SYSTEM'],
      idNo: json['ID_NO'] ?? '',
      paymentAuthority: json['PAYMENT_AUTHORITY'],
      accountNo: (json['P_ACCOUNT_NO'] as num?)?.toDouble() ?? 0.0,
      employeeChildren: json['P_EMPLOYEE_CHILDREN'],
      mobileNo: json['P_MOB_NO'],
      nationCode: json['P_NATION_CODE'],
      priorityName: json['PRIORITYName'] ?? '',
      authName: json['AUTHNAME'],
      email: json['E_MAIL'],
      password: json['password'] ?? '',
    );
  }

  /// 👇 Parsing القائمة اللي جاية كـ String
  static List<ParentProfileModel> fromApi(String data) {
    final decoded = jsonDecode(data) as List;
    return decoded.map((e) => ParentProfileModel.fromJson(e)).toList();
  }

  @override
  List<Object?> get props => [
    parentCode,
    parentNameAr,
    parentNameEng,
    fatherNameAr,
    fatherNameEng,
    prioritySystem,
    idNo,
    paymentAuthority,
    accountNo,
    employeeChildren,
    mobileNo,
    nationCode,
    priorityName,
    authName,
    email,
    password,
  ];
}
