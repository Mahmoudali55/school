import 'dart:convert';

import 'package:equatable/equatable.dart';

class GetIncomeListModel extends Equatable {
  final int? transNo;
  final String? transDate;
  final double? paidValue;
  final int? transType;
  final int? paymentType;
  final String? companyName;
  final String? companyNameEng;
  final String? addressAr;
  final String? addressEng;
  final double? vatValue;
  final String? notes;

  const GetIncomeListModel({
    this.transNo,
    this.transDate,
    this.paidValue,
    this.transType,
    this.paymentType,
    this.companyName,
    this.companyNameEng,
    this.addressAr,
    this.addressEng,
    this.vatValue,
    this.notes,
  });

  factory GetIncomeListModel.fromJson(Map<String, dynamic> json) {
    return GetIncomeListModel(
      transNo: json['TRANS_NO'],
      transDate: json['TRANS_DATE'],
      paidValue: (json['PAID_VALUE'] as num?)?.toDouble(),
      transType: json['TRANS_TYPE'],
      paymentType: json['PAYMENT_TYPE'],
      companyName: json['COMPANY_NAME'],
      companyNameEng: json['COMPANY_NAME_ENG'],
      addressAr: json['ADDRESS_AR'],
      addressEng: json['ADDRESS_ENG'],
      vatValue: (json['VAT_VALUE'] as num?)?.toDouble(),
      notes: json['NOTES'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TRANS_NO': transNo,
      'TRANS_DATE': transDate,
      'PAID_VALUE': paidValue,
      'TRANS_TYPE': transType,
      'PAYMENT_TYPE': paymentType,
      'COMPANY_NAME': companyName,
      'COMPANY_NAME_ENG': companyNameEng,
      'ADDRESS_AR': addressAr,
      'ADDRESS_ENG': addressEng,
      'VAT_VALUE': vatValue,
      'NOTES': notes,
    };
  }

  @override
  List<Object?> get props => [
    transNo,
    transDate,
    paidValue,
    transType,
    paymentType,
    companyName,
    companyNameEng,
    addressAr,
    addressEng,
    vatValue,
    notes,
  ];
  static List<GetIncomeListModel> listFromResponse(dynamic response) {
    final String dataString = response['Data'];

    final List decoded = jsonDecode(dataString);

    return decoded.map((e) => GetIncomeListModel.fromJson(e)).toList();
  }
}
