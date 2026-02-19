import 'dart:convert';

import 'package:equatable/equatable.dart';

class SchoolDataModel extends Equatable {
  final String? deltaConfig;
  final String? companyName;
  final String? companyNameEng;
  final String? addressAr;
  final String? addressEng;
  final String? eduStartDate;
  final String? secondTermDate;
  final String? startDate;
  final String? endDate;
  final int? discountCode;
  final int? discountRole;
  final int? expenseCodeOne;
  final int? expenseCodeTwo;
  final int? hijriGreg;
  final String? accountServer;
  final String? accountDatabase;
  final String? accountUser;
  final String? accountPw;
  final int? reportsRange;
  final bool? linkWithAcc;
  final int? decimal2;
  final int? decimal5;
  final int? paidPermDays;
  final int? parentAccType;
  final double? parentAccNo;
  final int? subVoucherCodes;
  final String? notes;
  final String? schoolCode;
  final int? wDiscountCode;
  final String? http;
  final String? cashAccNo;
  final String? tel1;
  final String? tel2;
  final String? fax;
  final String? accountServer1;
  final String? accountDatabase1;
  final String? accountUser1;
  final String? accountPw1;
  final bool? accDataClosed;
  final bool? accData1Closed;
  final bool? accPostingType;
  final int? reportsPrint;
  final String? branchNo;
  final int? wBDiffrent;
  final String? cashDiscountCode;
  final int? cashDiscountDays;
  final int? changeFinanDate;
  final double? vatAccNo;
  final double? vatPrec;
  final String? vatSerial;
  final int? docNature;
  final int? countryCode;
  final int? cityCode;
  final String? districtName;
  final String? streetName;
  final String? districtEname;
  final String? streetEname;
  final String? buildingNo;
  final String? postalNo;
  final String? additionNo;
  final String? tradeNam;
  final String? tradeReg;
  final String? glPath;
  final String? glExtent;
  final String? invoiceSign;
  final String? debitSign;
  final String? creditSign;
  final String? advanceSign;
  final bool? autoCode;
  final int? changeName;
  final String? cityName;
  final String? countryName;

  const SchoolDataModel({
    this.deltaConfig,
    this.companyName,
    this.companyNameEng,
    this.addressAr,
    this.addressEng,
    this.eduStartDate,
    this.secondTermDate,
    this.startDate,
    this.endDate,
    this.discountCode,
    this.discountRole,
    this.expenseCodeOne,
    this.expenseCodeTwo,
    this.hijriGreg,
    this.accountServer,
    this.accountDatabase,
    this.accountUser,
    this.accountPw,
    this.reportsRange,
    this.linkWithAcc,
    this.decimal2,
    this.decimal5,
    this.paidPermDays,
    this.parentAccType,
    this.parentAccNo,
    this.subVoucherCodes,
    this.notes,
    this.schoolCode,
    this.wDiscountCode,
    this.http,
    this.cashAccNo,
    this.tel1,
    this.tel2,
    this.fax,
    this.accountServer1,
    this.accountDatabase1,
    this.accountUser1,
    this.accountPw1,
    this.accDataClosed,
    this.accData1Closed,
    this.accPostingType,
    this.reportsPrint,
    this.branchNo,
    this.wBDiffrent,
    this.cashDiscountCode,
    this.cashDiscountDays,
    this.changeFinanDate,
    this.vatAccNo,
    this.vatPrec,
    this.vatSerial,
    this.docNature,
    this.countryCode,
    this.cityCode,
    this.districtName,
    this.streetName,
    this.districtEname,
    this.streetEname,
    this.buildingNo,
    this.postalNo,
    this.additionNo,
    this.tradeNam,
    this.tradeReg,
    this.glPath,
    this.glExtent,
    this.invoiceSign,
    this.debitSign,
    this.creditSign,
    this.advanceSign,
    this.autoCode,
    this.changeName,
    this.cityName,
    this.countryName,
  });

  factory SchoolDataModel.fromJson(Map<String, dynamic> json) {
    return SchoolDataModel(
      deltaConfig: json['DELTACONFIG'],
      companyName: json['COMPANY_NAME'],
      companyNameEng: json['COMPANY_NAME_ENG'],
      addressAr: json['ADDRESS_AR'],
      addressEng: json['ADDRESS_ENG'],
      eduStartDate: json['EDU_START_DATE'],
      secondTermDate: json['SECOND_TERM_DATE'],
      startDate: json['START_DATE'],
      endDate: json['END_DATE'],
      discountCode: json['DISCOUNT_CODE'],
      discountRole: json['DISCOUNT_ROLE'],
      expenseCodeOne: json['EXPENSE_CODE_ONE'],
      expenseCodeTwo: json['EXPENSE_CODE_TWO'],
      hijriGreg: json['HIJRI_GREG'],
      accountServer: json['ACCOUNT_SERVER'],
      accountDatabase: json['ACCOUNT_DATABASE'],
      accountUser: json['ACCOUNT_USER'],
      accountPw: json['ACCOUNT_PW'],
      reportsRange: json['REPORTS_RANGE'],
      linkWithAcc: json['LINK_WITH_ACC'],
      decimal2: json['DECIMAL2'],
      decimal5: json['DECIMAL5'],
      paidPermDays: json['PAID_PERM_DAYS'],
      parentAccType: json['PARENT_ACC_TYPE'],
      parentAccNo: (json['PARENT_ACC_NO'] as num?)?.toDouble(),
      subVoucherCodes: json['SUB_VOUCHER_CODES'],
      notes: json['NOTES'],
      schoolCode: json['SCHOOL_CODE'],
      wDiscountCode: json['W_DISCOUNT_CODE'],
      http: json['HTTP'],
      cashAccNo: json['CASH_ACC_NO'],
      tel1: json['TEL1'],
      tel2: json['TEL2'],
      fax: json['FAX'],
      accountServer1: json['ACCOUNT_SERVER1'],
      accountDatabase1: json['ACCOUNT_DATABASE1'],
      accountUser1: json['ACCOUNT_USER1'],
      accountPw1: json['ACCOUNT_PW1'],
      accDataClosed: json['ACC_DATA_CLOSED'],
      accData1Closed: json['ACC_DATA1_CLOSED'],
      accPostingType: json['ACC_POSTING_TYPE'],
      reportsPrint: json['REPORTS_PRINT'],
      branchNo: json['BRANCH_NO'],
      wBDiffrent: json['W_B_DIFFRENT'],
      cashDiscountCode: json['CASH_DISCOUNT_CODE'],
      cashDiscountDays: json['CASH_DISCOUNT_DAYS'],
      changeFinanDate: json['CHANGE_FINAN_DATE'],
      vatAccNo: (json['VAT_ACC_NO'] as num?)?.toDouble(),
      vatPrec: (json['VAT_PREC'] as num?)?.toDouble(),
      vatSerial: json['VAT_SERIAL'],
      docNature: json['DOC_NATURE'],
      countryCode: json['COUNTRY_CODE'],
      cityCode: json['CITY_CODE'],
      districtName: json['DISTRICT_NAME'],
      streetName: json['STREET_NAME'],
      districtEname: json['DISTRICT_ENAME'],
      streetEname: json['STREET_ENAME'],
      buildingNo: json['BUILDING_NO'],
      postalNo: json['POSTAL_NO'],
      additionNo: json['ADDITION_NO'],
      tradeNam: json['TRADE_NAM'],
      tradeReg: json['TRADE_REG'],
      glPath: json['GL_PATH'],
      glExtent: json['GL_EXTENT'],
      invoiceSign: json['INVOICE_SIGN'],
      debitSign: json['DEBIT_SIGN'],
      creditSign: json['CREDIT_SIGN'],
      advanceSign: json['ADVANCE_SIGN'],
      autoCode: json['autocode'],
      changeName: json['changeName'],
      cityName: json['CITY_NAME'],
      countryName: json['COUNTRY_NAME'],
    );
  }

  static List<SchoolDataModel> listFromResponse(dynamic response) {
    final decodedData = jsonDecode(response['Data']);
    return List<SchoolDataModel>.from(decodedData.map((e) => SchoolDataModel.fromJson(e)));
  }

  @override
  List<Object?> get props => [
    deltaConfig,
    companyName,
    companyNameEng,
    addressAr,
    addressEng,
    eduStartDate,
    secondTermDate,
    startDate,
    endDate,
    discountCode,
    discountRole,
    expenseCodeOne,
    expenseCodeTwo,
    hijriGreg,
    accountServer,
    accountDatabase,
    accountUser,
    accountPw,
    reportsRange,
    linkWithAcc,
    decimal2,
    decimal5,
    paidPermDays,
    parentAccType,
    parentAccNo,
    subVoucherCodes,
    notes,
    schoolCode,
    wDiscountCode,
    http,
    cashAccNo,
    tel1,
    tel2,
    fax,
    accountServer1,
    accountDatabase1,
    accountUser1,
    accountPw1,
    accDataClosed,
    accData1Closed,
    accPostingType,
    reportsPrint,
    branchNo,
    wBDiffrent,
    cashDiscountCode,
    cashDiscountDays,
    changeFinanDate,
    vatAccNo,
    vatPrec,
    vatSerial,
    docNature,
    countryCode,
    cityCode,
    districtName,
    streetName,
    districtEname,
    streetEname,
    buildingNo,
    postalNo,
    additionNo,
    tradeNam,
    tradeReg,
    glPath,
    glExtent,
    invoiceSign,
    debitSign,
    creditSign,
    advanceSign,
    autoCode,
    changeName,
    cityName,
    countryName,
  ];
}
