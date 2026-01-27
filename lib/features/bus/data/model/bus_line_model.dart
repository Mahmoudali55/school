import 'dart:convert';

import 'package:equatable/equatable.dart';

class BusLine extends Equatable {
  final int busCode;
  final double? accountNo;
  final int busLineCode;
  final int busDriverCode;
  final int busSectionCode;
  final int busSets;
  final int? busSupervisorCode1;
  final int? busSupervisorCode2;
  final String busType;
  final String modelNo;
  final String plateNo;
  final int busState;
  final String busSectionName;
  final String accountName;
  final String busDriverName;
  final String busSupervisorName1;
  final String? busSupervisorName2;
  final String busLineName;
  final int busSetsUsed;
  final int busSetsAvailable;
  final String mobileNo;
  final String? supMobileNo;
  final String? supMobileNo2;

  const BusLine({
    required this.busCode,
    required this.accountNo,
    required this.busLineCode,
    required this.busDriverCode,
    required this.busSectionCode,
    required this.busSets,
    required this.busSupervisorCode1,
    required this.busSupervisorCode2,
    required this.busType,
    required this.modelNo,
    required this.plateNo,
    required this.busState,
    required this.busSectionName,
    required this.accountName,
    required this.busDriverName,
    required this.busSupervisorName1,
    required this.busSupervisorName2,
    required this.busLineName,
    required this.busSetsUsed,
    required this.busSetsAvailable,
    required this.mobileNo,
    required this.supMobileNo,
    required this.supMobileNo2,
  });

  factory BusLine.fromJson(Map<String, dynamic> json) {
    return BusLine(
      busCode: json['BUS_CODE'],
      accountNo: (json['B_ACCOUNT_NO'] as num?)?.toDouble(),
      busLineCode: json['BUS_LINE_CODE'],
      busDriverCode: json['BUS_DRIVER_CODE'],
      busSectionCode: json['BUS_SECTION_CODE'],
      busSets: json['BUS_SETS'],
      busSupervisorCode1: json['BUS_SUPERVISOR_CODE1'],
      busSupervisorCode2: json['BUS_SUPERVISOR_CODE2'],
      busType: json['BUS_TYPE'],
      modelNo: json['MODEL_NO'],
      plateNo: json['PLATE_NO'],
      busState: json['BUS_STATE'],
      busSectionName: json['BUSSECTIONNAME'],
      accountName: json['ACCOUNTName'],
      busDriverName: json['BUSDRIVERNAME'],
      busSupervisorName1: json['BUSSUPERVISORNAME1'],
      busSupervisorName2: json['BUSSUPERVISORNAME2'],
      busLineName: json['BUSLINEName'],
      busSetsUsed: json['BUSSETSUsed'],
      busSetsAvailable: json['BUSSETSAvaliabel'],
      mobileNo: json['MOBILE_NO'],
      supMobileNo: json['SUP_MOBILE_NO'],
      supMobileNo2: json['SUP_MOBILE_NO2'],
    );
  }

  /// 🔹 مهم جدًا: تحويل Data (String) → List<BusLine>
  static List<BusLine> fromDataString(String data) {
    final List decoded = jsonDecode(data);
    return decoded.map((e) => BusLine.fromJson(e)).toList();
  }

  @override
  List<Object?> get props => [
    busCode,
    accountNo,
    busLineCode,
    busDriverCode,
    busSectionCode,
    busSets,
    busSupervisorCode1,
    busSupervisorCode2,
    busType,
    modelNo,
    plateNo,
    busState,
    busSectionName,
    accountName,
    busDriverName,
    busSupervisorName1,
    busSupervisorName2,
    busLineName,
    busSetsUsed,
    busSetsAvailable,
    mobileNo,
    supMobileNo,
    supMobileNo2,
  ];
}
