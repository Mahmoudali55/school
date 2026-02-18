import 'dart:convert';

import 'package:equatable/equatable.dart';

class BusDataModel extends Equatable {
  final int? busCode;
  final String? plateNo;
  final String? busType;
  final String? modelNo;
  final int? fuelType;
  final String? lineNameAr;
  final String? driverNameAr;
  final String? driverMobile;
  final String? supervisorNameAr1;
  final String? supervisorNameAr2;
  final String? supervisorMobile1;
  final String? supervisorMobile2;
  final String? sectionNameAr;
  final String? companyName;
  final String? addressAr;
  final int? busSets;
  final String? bAppStartDate;
  final String? bAppEndDate;
  final String? eduStartDate;
  final String? secondTermDate;
  const BusDataModel({
    this.busCode,
    this.plateNo,
    this.busType,
    this.modelNo,
    this.fuelType,
    this.lineNameAr,
    this.driverNameAr,
    this.driverMobile,
    this.supervisorNameAr1,
    this.supervisorNameAr2,
    this.supervisorMobile1,
    this.supervisorMobile2,
    this.sectionNameAr,
    this.companyName,
    this.addressAr,
    this.busSets,
    this.bAppStartDate,
    this.bAppEndDate,
    this.eduStartDate,
    this.secondTermDate,
  });

  factory BusDataModel.fromMap(Map<String, dynamic> map) {
    return BusDataModel(
      busCode: map['BUS_CODE'],
      plateNo: map['PLATE_NO'],
      busType: map['BUS_TYPE'],
      modelNo: map['MODEL_NO'],
      fuelType: map['FUEL_TYPE'],
      lineNameAr: map['LINE_NAME_AR'],
      driverNameAr: map['DRIVER_NAME_AR'],
      driverMobile: map['D_MOBILE_NO'],
      supervisorNameAr1: map['SUPERVISOR_NAME_AR1'],
      supervisorNameAr2: map['SUPERVISOR_NAME_AR2'],
      supervisorMobile1: map['SUP_MOBILE_NO1'],
      supervisorMobile2: map['SUP_MOBILE_NO2'],
      sectionNameAr: map['SECTION_NAME_AR'],
      companyName: map['COMPANY_NAME'],
      addressAr: map['ADDRESS_AR'],
      busSets: map['BUS_SETS'],
      bAppStartDate: map['B_APP_START_DATE'],
      bAppEndDate: map['B_APP_END_DATE'],
      eduStartDate: map['EDU_START_DATE'],
      secondTermDate: map['SECOND_TERM_DATE'],
    );
  }

  static List<BusDataModel> listFromResponse(Map<String, dynamic> response) {
    final String dataString = response['Data'] ?? "[]";

    final List decoded = json.decode(dataString);

    return decoded.map((e) => BusDataModel.fromMap(e)).toList();
  }

  @override
  List<Object?> get props => [
    busCode,
    plateNo,
    busType,
    modelNo,
    fuelType,
    lineNameAr,
    driverNameAr,
    driverMobile,
    supervisorNameAr1,
    supervisorNameAr2,
    supervisorMobile1,
    supervisorMobile2,
    sectionNameAr,
    companyName,
    addressAr,
    busSets,
    bAppStartDate,
    bAppEndDate,
    eduStartDate,
    secondTermDate,
  ];
}
