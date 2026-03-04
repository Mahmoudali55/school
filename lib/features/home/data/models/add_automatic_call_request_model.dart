import 'package:equatable/equatable.dart';

class AddAutomaticCallRequestModel extends Equatable {
  final List<AutomaticCallItem> automaticCall;

  const AddAutomaticCallRequestModel({required this.automaticCall});

  factory AddAutomaticCallRequestModel.fromJson(Map<String, dynamic> json) {
    return AddAutomaticCallRequestModel(
      automaticCall:
          (json['AutomaticCall'] as List<dynamic>?)
              ?.map((e) => AutomaticCallItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {"AutomaticCall": automaticCall.map((e) => e.toJson()).toList()};
  }

  @override
  List<Object?> get props => [automaticCall];
}

class AutomaticCallItem extends Equatable {
  final String id;
  final String transdate;
  final int studentcode;
  final int stageCode;
  final String notes;
  final int flag;

  const AutomaticCallItem({
    required this.id,
    required this.transdate,
    required this.studentcode,
    required this.stageCode,
    required this.notes,
    required this.flag,
  });

  factory AutomaticCallItem.fromJson(Map<String, dynamic> json) {
    return AutomaticCallItem(
      id: json['Id'] as String? ?? '',
      transdate: json['Transdate'] as String? ?? '',
      studentcode: json['Studentcode'] as int? ?? 0,
      stageCode: json['StageCode'] as int? ?? 0,
      notes: json['Notes'] as String? ?? '',
      flag: json['Flag'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      "Transdate": transdate,
      "Studentcode": studentcode,
      "StageCode": stageCode,
      "Notes": notes,
      "Flag": flag,
    };
  }

  @override
  List<Object?> get props => [id, transdate, studentcode, stageCode, notes, flag];
}
