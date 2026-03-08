import 'package:equatable/equatable.dart';

class ParentRegistrationModel extends Equatable {
  final String pRegCode;
  final String pFirstName;
  final String pSecondName;
  final String pGrandName;
  final String pFamilyName;
  final int pNationCode;
  final int pReligionCode;
  final int idType;
  final String idNo;
  final String pPassportNo;
  final String pMobNo;
  final int pGender;
  final String username;
  final List<StudentRegistrationModel> registrationStudents;

  const ParentRegistrationModel({
    this.pRegCode = "",
    required this.pFirstName,
    required this.pSecondName,
    required this.pGrandName,
    required this.pFamilyName,
    required this.pNationCode,
    required this.pReligionCode,
    required this.idType,
    required this.idNo,
    required this.pPassportNo,
    required this.pMobNo,
    required this.pGender,
    this.username = "",
    required this.registrationStudents,
  });

  Map<String, dynamic> toJson() => {
    "PREGCODE": pRegCode,
    "PFIRSTNAME": pFirstName,
    "PSECONDNAME": pSecondName,
    "PGRANDNAME": pGrandName,
    "PFAMILYNAME": pFamilyName,
    "PNATIONCODE": pNationCode,
    "PRELIGIONCODE": pReligionCode,
    "IDTYPE": idType,
    "IDNO": idNo,
    "PPASSPORTNO": pPassportNo,
    "PMOBNO": pMobNo,
    "PGENDER": pGender,
    "username": username,
    "REGISTRATIONSTUDENT": registrationStudents.map((x) => x.toJson()).toList(),
  };

  @override
  List<Object?> get props => [
    pRegCode,
    pFirstName,
    pSecondName,
    pGrandName,
    pFamilyName,
    pNationCode,
    pReligionCode,
    idType,
    idNo,
    pPassportNo,
    pMobNo,
    pGender,
    username,
    registrationStudents,
  ];
}

class StudentRegistrationModel extends Equatable {
  final String sRegCodes;
  final String sRegCode;
  final String sFirstName;
  final String sIdNo;
  final String regDate;
  final String birthDate;
  final int ageYear;
  final int ageMonth;
  final int ageDay;
  final int gender;
  final int sectionCode;
  final int stageCode;
  final int levelCode;

  const StudentRegistrationModel({
    this.sRegCodes = "",
    this.sRegCode = "",
    required this.sFirstName,
    required this.sIdNo,
    required this.regDate,
    required this.birthDate,
    required this.ageYear,
    required this.ageMonth,
    required this.ageDay,
    required this.gender,
    required this.sectionCode,
    required this.stageCode,
    required this.levelCode,
  });

  Map<String, dynamic> toJson() => {
    "SREGCODEs": sRegCodes,
    "SREGCODE": sRegCode,
    "SFIRSTNAME": sFirstName,
    "SIDNO": sIdNo,
    "REGDATE": regDate,
    "BIRTHDATE": birthDate,
    "AGEYEAR": ageYear,
    "AGEMONTH": ageMonth,
    "AGEDAY": ageDay,
    "GENDER": gender,
    "SECTIONCODE": sectionCode,
    "STAGECODE": stageCode,
    "LEVELCODE": levelCode,
  };

  @override
  List<Object?> get props => [
    sRegCodes,
    sRegCode,
    sFirstName,
    sIdNo,
    regDate,
    birthDate,
    ageYear,
    ageMonth,
    ageDay,
    gender,
    sectionCode,
    stageCode,
    levelCode,
  ];
}
