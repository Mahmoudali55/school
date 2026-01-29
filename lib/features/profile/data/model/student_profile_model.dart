import 'package:equatable/equatable.dart';

class StudentProfileModel extends Equatable {
  final int parentCode;
  final String firstNameAr;
  final String firstNameEn;
  final String regDate;
  final String birthDate;
  final int ageYear;
  final int ageMonth;
  final int ageDay;
  final int sectionCode;
  final int stageCode;
  final int levelCode;
  final int classCode;
  final int prioritySystem;
  final int installmentType;
  final int gender;
  final int employeeChildren;
  final String? comeFrom;
  final String enteringDate;
  final String idNo;
  final int sState;
  final int studentCode;
  final String studentFullName;
  final String parentName;
  final String? jobName;
  final String prioritySystemName;
  final String sectionName;
  final String stageName;
  final String levelName;
  final String className;
  final String sStateName;
  final int busCode;
  final int transportType;
  final int busCode2;
  final int transportType2;

  const StudentProfileModel({
    required this.parentCode,
    required this.firstNameAr,
    required this.firstNameEn,
    required this.regDate,
    required this.birthDate,
    required this.ageYear,
    required this.ageMonth,
    required this.ageDay,
    required this.sectionCode,
    required this.stageCode,
    required this.levelCode,
    required this.classCode,
    required this.prioritySystem,
    required this.installmentType,
    required this.gender,
    required this.employeeChildren,
    required this.comeFrom,
    required this.enteringDate,
    required this.idNo,
    required this.sState,
    required this.studentCode,
    required this.studentFullName,
    required this.parentName,
    required this.jobName,
    required this.prioritySystemName,
    required this.sectionName,
    required this.stageName,
    required this.levelName,
    required this.className,
    required this.sStateName,
    required this.busCode,
    required this.transportType,
    required this.busCode2,
    required this.transportType2,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      parentCode: json['PARENT_CODE'],
      firstNameAr: json['S_FIRST_NAME_AR'],
      firstNameEn: json['S_FIRST_NAME_ENG'],
      regDate: json['REG_DATE'],
      birthDate: json['BIRTH_DATE'],
      ageYear: json['AGE_YEAR'],
      ageMonth: json['AGE_MONTH'],
      ageDay: json['AGE_DAY'],
      sectionCode: json['SECTION_CODE'],
      stageCode: json['STAGE_CODE'],
      levelCode: json['LEVEL_CODE'],
      classCode: json['CLASS_CODE'],
      prioritySystem: json['PRIORITY_SYSTEM'],
      installmentType: json['INSTALLMENT_TYPE'],
      gender: json['GENDER'],
      employeeChildren: json['EMPLOYEE_CHILDREN'],
      comeFrom: json['COME_FROM'],
      enteringDate: json['ENTERING_DATE'],
      idNo: json['IDNO'],
      sState: json['S_STATE'],
      studentCode: json['STUDENT_CODE'],
      studentFullName: json['StudentfullName'],
      parentName: json['ParentName'],
      jobName: json['JOBNAME'],
      prioritySystemName: json['PRI_SYS_NAME'],
      sectionName: json['SectionName'],
      stageName: json['StageName'],
      levelName: json['LevelName'],
      className: json['ClassName'],
      sStateName: json['SSTATEName'],
      busCode: json['BUS_CODE'],
      transportType: json['TRANSPORT_TYPE'],
      busCode2: json['BUS_CODE2'],
      transportType2: json['TRANSPORT_TYPE2'],
    );
  }

  @override
  List<Object?> get props => [
    parentCode,
    firstNameAr,
    firstNameEn,
    regDate,
    birthDate,
    ageYear,
    ageMonth,
    ageDay,
    sectionCode,
    stageCode,
    levelCode,
    classCode,
    prioritySystem,
    installmentType,
    gender,
    employeeChildren,
    comeFrom,
    enteringDate,
    idNo,
    sState,
    studentCode,
    studentFullName,
    parentName,
    jobName,
    prioritySystemName,
    sectionName,
    stageName,
    levelName,
    className,
    sStateName,
    busCode,
    transportType,
    busCode2,
    transportType2,
  ];
}
