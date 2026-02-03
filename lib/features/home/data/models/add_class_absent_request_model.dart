import 'package:equatable/equatable.dart';

class AddClassAbsentRequestModel extends Equatable {
  final String classCodes;
  final int sectionCode;
  final int stageCode;
  final int levelCode;
  final int classCode;
  final String absentDate;
  final String notes;
  final List<ClassAbsentItem> classAbsentList;

  const AddClassAbsentRequestModel({
    required this.classCodes,
    required this.sectionCode,
    required this.stageCode,
    required this.levelCode,
    required this.classCode,
    required this.absentDate,
    required this.notes,
    required this.classAbsentList,
  });

  Map<String, dynamic> toJson() {
    return {
      "classcodes": classCodes,
      "SECTIONCODE": sectionCode,
      "STAGECODE": stageCode,
      "LEVELCODE": levelCode,
      "classcode": classCode,
      "ABSENTDATE": absentDate,
      "NOTES": notes,
      "classAbsent_d": classAbsentList.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object> get props => [
    classCodes,
    sectionCode,
    stageCode,
    levelCode,
    classCode,
    absentDate,
    notes,
    classAbsentList,
  ];
}

class ClassAbsentItem extends Equatable {
  final int studentCode;
  final String absentDate;
  final int absentType; // 0 = غياب | 1 = إجازة
  final String notes;

  const ClassAbsentItem({
    required this.studentCode,
    required this.absentDate,
    required this.absentType,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      "STUDENT_CODE": studentCode,
      "ABSENTDATE": absentDate,
      "ABSENT_TYPE": absentType,
      "NOTES": notes,
    };
  }

  @override
  List<Object> get props => [studentCode, absentDate, absentType, notes];
}
