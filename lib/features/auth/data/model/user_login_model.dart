import 'package:equatable/equatable.dart';

class UserLoginModel extends Equatable {
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final String userName;
  final String userId;
  final String compneyName;
  final String changeName;
  final String autoCode;
  final String eduStartDate;
  final String secondTermDate;
  final String vatPrec;
  final String paidPermDays;
  final String changeFinanDate;
  final String linkWithAcc;
  final String code;
  final String name;
  final String sectionCode;
  final String stageCode;
  final String levelCode;
  final String classCode;
  final String sOpeningBalance;
  final String type;
  final String issued;
  final String expires;

  const UserLoginModel({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.userName,
    required this.userId,
    required this.compneyName,
    required this.changeName,
    required this.autoCode,
    required this.eduStartDate,
    required this.secondTermDate,
    required this.vatPrec,
    required this.paidPermDays,
    required this.changeFinanDate,
    required this.linkWithAcc,
    required this.code,
    required this.name,
    required this.sectionCode,
    required this.stageCode,
    required this.levelCode,
    required this.classCode,
    required this.sOpeningBalance,
    required this.type,
    required this.issued,
    required this.expires,
  });

  factory UserLoginModel.fromJson(Map<String, dynamic> json) {
    return UserLoginModel(
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'] ?? '',
      expiresIn: json['expires_in'] ?? 0,
      userName: json['userName'] ?? '',
      userId: json['userid'] ?? '',
      compneyName: json['compneyname'] ?? '',
      changeName: json['ChangeName'] ?? '',
      autoCode: json['autocode'] ?? '',
      eduStartDate: json['EDU_START_DATE'] ?? '',
      secondTermDate: json['SECOND_TERM_DATE'] ?? '',
      vatPrec: json['VAT_PREC'] ?? '',
      paidPermDays: json['PAID_PERM_DAYS'] ?? '',
      changeFinanDate: json['CHANGE_FINAN_DATE'] ?? '',
      linkWithAcc: json['LINK_WITH_ACC'] ?? '',
      code: json['Code'] ?? '',
      name: json['Name'] ?? '',
      sectionCode: json['SECTION_CODE'] ?? '',
      stageCode: json['STAGE_CODE'] ?? '',
      levelCode: json['LEVEL_CODE'] ?? '',
      classCode: json['CLASS_CODE'] ?? '',
      sOpeningBalance: json['S_OPENING_BALANCE'] ?? '',
      type: json['type'] ?? '',
      issued: json['.issued'] ?? '',
      expires: json['.expires'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'userName': userName,
      'userid': userId,
      'compneyname': compneyName,
      'ChangeName': changeName,
      'autocode': autoCode,
      'EDU_START_DATE': eduStartDate,
      'SECOND_TERM_DATE': secondTermDate,
      'VAT_PREC': vatPrec,
      'PAID_PERM_DAYS': paidPermDays,
      'CHANGE_FINAN_DATE': changeFinanDate,
      'LINK_WITH_ACC': linkWithAcc,
      'Code': code,
      'Name': name,
      'SECTION_CODE': sectionCode,
      'STAGE_CODE': stageCode,
      'LEVEL_CODE': levelCode,
      'CLASS_CODE': classCode,
      'S_OPENING_BALANCE': sOpeningBalance,
      'type': type,
      '.issued': issued,
      '.expires': expires,
    };
  }

  @override
  List<Object?> get props => [
    accessToken,
    tokenType,
    expiresIn,
    userName,
    userId,
    compneyName,
    changeName,
    autoCode,
    eduStartDate,
    secondTermDate,
    vatPrec,
    paidPermDays,
    changeFinanDate,
    linkWithAcc,
    code,
    name,
    sectionCode,
    stageCode,
    levelCode,
    classCode,
    sOpeningBalance,
    type,
    issued,
    expires,
  ];
}
