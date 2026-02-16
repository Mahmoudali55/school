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
  final String? supervisorNameAr1;
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
    this.supervisorNameAr1,
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
      supervisorNameAr1: map['SUPERVISOR_NAME_AR1'],
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

  Map<String, dynamic> toMap() {
    return {
      'BUS_CODE': busCode,
      'PLATE_NO': plateNo,
      'BUS_TYPE': busType,
      'MODEL_NO': modelNo,
      'FUEL_TYPE': fuelType,
      'LINE_NAME_AR': lineNameAr,
      'DRIVER_NAME_AR': driverNameAr,
      'SUPERVISOR_NAME_AR1': supervisorNameAr1,
      'SECTION_NAME_AR': sectionNameAr,
      'COMPANY_NAME': companyName,
      'ADDRESS_AR': addressAr,
      'BUS_SETS': busSets,
      'B_APP_START_DATE': bAppStartDate,
      'B_APP_END_DATE': bAppEndDate,
      'EDU_START_DATE': eduStartDate,
      'SECOND_TERM_DATE': secondTermDate,
    };
  }

  static List<BusDataModel> listFromJson(String source) {
    final List decoded = json.decode(source);
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
    supervisorNameAr1,
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
