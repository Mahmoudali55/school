import 'dart:convert';

import 'package:equatable/equatable.dart';

class StageDataModel extends Equatable {
  final String deltaConfig;
  final int sectionCode;
  final int stageCode;
  final String stageNameAr;
  final String stageNameEng;
  final int levelNo;
  final String? notes;
  final String? schoolCode;
  final double? costCenterNo;
  final String? cashAccNo;
  final String? salaryAccNo;
  final String? bankAccNo;

  const StageDataModel({
    required this.deltaConfig,
    required this.sectionCode,
    required this.stageCode,
    required this.stageNameAr,
    required this.stageNameEng,
    required this.levelNo,
    this.notes,
    this.schoolCode,
    this.costCenterNo,
    this.cashAccNo,
    this.salaryAccNo,
    this.bankAccNo,
  });

  /// من JSON string لكائن Dart
  factory StageDataModel.fromJson(Map<String, dynamic> json) {
    return StageDataModel(
      deltaConfig: json['DELTACONFIG'] ?? '',
      sectionCode: json['SECTION_CODE'] ?? 0,
      stageCode: json['STAGE_CODE'] ?? 0,
      stageNameAr: json['STAGE_NAME_AR'] ?? '',
      stageNameEng: json['STAGE_NAME_ENG'] ?? '',
      levelNo: json['LEVEL_NO'] ?? 0,
      notes: json['NOTES'],
      schoolCode: json['SCHOOL_CODE']?.toString(),
      costCenterNo: json['COST_CENTER_NO'] != null
          ? double.tryParse(json['COST_CENTER_NO'].toString())
          : null,
      cashAccNo: json['CASH_ACC_NO']?.toString(),
      salaryAccNo: json['SALARY_ACC_NO']?.toString(),
      bankAccNo: json['BANK_ACC_NO']?.toString(),
    );
  }

  /// لتحويل كائن Dart إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'DELTACONFIG': deltaConfig,
      'SECTION_CODE': sectionCode,
      'STAGE_CODE': stageCode,
      'STAGE_NAME_AR': stageNameAr,
      'STAGE_NAME_ENG': stageNameEng,
      'LEVEL_NO': levelNo,
      'NOTES': notes,
      'SCHOOL_CODE': schoolCode,
      'COST_CENTER_NO': costCenterNo,
      'CASH_ACC_NO': cashAccNo,
      'SALARY_ACC_NO': salaryAccNo,
      'BANK_ACC_NO': bankAccNo,
    };
  }

  /// لتحويل JSON string كامل لقائمة من الكائنات
  static List<StageDataModel> listFromJson(String jsonString) {
    final decoded = json.decode(jsonString);
    if (decoded is List) {
      return decoded.map((e) => StageDataModel.fromJson(e)).toList();
    } else if (decoded is Map<String, dynamic>) {
      final dynamic data = decoded['Data'];
      if (data is String) {
        final List<dynamic> dataList = json.decode(data);
        return dataList.map((e) => StageDataModel.fromJson(e)).toList();
      } else if (data is List) {
        return data.map((e) => StageDataModel.fromJson(e)).toList();
      }
    }
    return [];
  }

  @override
  List<Object?> get props => [
    deltaConfig,
    sectionCode,
    stageCode,
    stageNameAr,
    stageNameEng,
    levelNo,
    notes,
    schoolCode,
    costCenterNo,
    cashAccNo,
    salaryAccNo,
    bankAccNo,
  ];
}
