import 'package:equatable/equatable.dart';

class AdmissionRequestModel extends Equatable {
  final String parentFirstName;
  final String parentLastName;
  final String parentFamilyName;
  final String parentGrandfatherName;
  final String parentNationality;
  final String parentReligion;
  final String parentResidencyType;
  final String parentPhone;
  final String parentGender;
  final String parentPassportNumber;
  final String parentNationalId;
  final int studentCount;
  final List<StudentAdmissionModel> students;

  const AdmissionRequestModel({
    required this.parentFirstName,
    required this.parentLastName,
    required this.parentFamilyName,
    required this.parentGrandfatherName,
    required this.parentNationality,
    required this.parentReligion,
    required this.parentResidencyType,
    required this.parentPhone,
    required this.parentGender,
    required this.parentPassportNumber,
    required this.parentNationalId,
    required this.studentCount,
    required this.students,
  });

  Map<String, dynamic> toJson() => {
    'ParentFirstName': parentFirstName,
    'ParentLastName': parentLastName,
    'ParentFamilyName': parentFamilyName,
    'ParentGrandfatherName': parentGrandfatherName,
    'ParentNationality': parentNationality,
    'ParentReligion': parentReligion,
    'ParentResidencyType': parentResidencyType,
    'ParentPhone': parentPhone,
    'ParentGender': parentGender,
    'ParentPassportNumber': parentPassportNumber,
    'ParentNationalId': parentNationalId,
    'StudentCount': studentCount,
    'Students': students.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [
    parentFirstName,
    parentLastName,
    parentFamilyName,
    parentGrandfatherName,
    parentNationality,
    parentReligion,
    parentResidencyType,
    parentPhone,
    parentGender,
    parentPassportNumber,
    parentNationalId,
    studentCount,
    students,
  ];
}

class StudentAdmissionModel extends Equatable {
  final String studentName;
  final String registrationDate;
  final String studentBirthDate;
  final String studentIdNo;
  final String gender;
  final String section;
  final String stage;
  final String grade;

  const StudentAdmissionModel({
    required this.studentName,
    required this.registrationDate,
    required this.studentBirthDate,
    required this.studentIdNo,
    required this.gender,
    required this.section,
    required this.stage,
    required this.grade,
  });

  Map<String, dynamic> toJson() => {
    'StudentName': studentName,
    'RegistrationDate': registrationDate,
    'StudentBirthDate': studentBirthDate,
    'StudentIdNo': studentIdNo,
    'Gender': gender,
    'Section': section,
    'Stage': stage,
    'Grade': grade,
  };

  @override
  List<Object?> get props => [
    studentName,
    registrationDate,
    studentBirthDate,
    studentIdNo,
    gender,
    section,
    stage,
    grade,
  ];
}
