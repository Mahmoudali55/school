import 'package:equatable/equatable.dart';
import 'package:my_template/features/home/data/models/home_work_details_model.dart';

class AddHomeworkModelRequest extends Equatable {
  final String classCodes;
  final int sectionCode;
  final int stageCode;
  final int level;
  final int classCode;
  final String hwDate;
  final String? notes;
  final List<HomeworkDetailsModel> homeworkDetails;

  const AddHomeworkModelRequest({
    required this.classCodes,
    required this.sectionCode,
    required this.stageCode,
    required this.level,
    required this.classCode,
    required this.hwDate,
    this.notes,
    required this.homeworkDetails,
  });

  factory AddHomeworkModelRequest.fromJson(Map<String, dynamic> json) {
    return AddHomeworkModelRequest(
      classCodes: json['classcodes'] as String,
      sectionCode: json['SECTIONCODE'] as int,
      stageCode: json['STAGECODE'] as int,
      level: json['level'] as int,
      classCode: json['classcode'] as int,
      hwDate: json['HWDATE'] as String,
      notes: json['NOTES'],
      homeworkDetails: (json['homework_D'] as List<dynamic>)
          .map((e) => HomeworkDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classcodes': classCodes,
      'SECTIONCODE': sectionCode,
      'STAGECODE': stageCode,
      'level': level,
      'classcode': classCode,
      'HWDATE': hwDate,
      'NOTES': notes,
      'homework_D': homeworkDetails.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
    classCodes,
    sectionCode,
    stageCode,
    level,
    classCode,
    hwDate,
    notes,
    homeworkDetails,
  ];
}
