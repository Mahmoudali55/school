import 'dart:convert';

import 'package:equatable/equatable.dart';

class GetAutomaticCallModel extends Equatable {
  final List<AutomaticCallItem> data;

  const GetAutomaticCallModel({required this.data});

  factory GetAutomaticCallModel.fromJson(Map<String, dynamic> json) {
    // البيانات في JSON على شكل String داخل "Data"
    final rawData = json['Data'] as String? ?? '[]';
    final List<dynamic> parsedList = jsonDecode(rawData);

    return GetAutomaticCallModel(
      data: parsedList.map((e) => AutomaticCallItem.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {"Data": jsonEncode(data.map((e) => e.toJson()).toList())};
  }

  @override
  List<Object?> get props => [data];
}

class AutomaticCallItem extends Equatable {
  final int id;
  final String transdate;
  final int studentcode;
  final int stageCode;
  final String notes;
  final int flag;
  final String studentname;

  const AutomaticCallItem({
    required this.id,
    required this.transdate,
    required this.studentcode,
    required this.stageCode,
    required this.notes,
    required this.flag,
    required this.studentname,
  });

  factory AutomaticCallItem.fromJson(Map<String, dynamic> json) {
    return AutomaticCallItem(
      id: json['id'] as int? ?? 0,
      transdate: json['transdate'] as String? ?? '',
      studentcode: json['studentcode'] as int? ?? 0,
      stageCode: json['StageCode'] as int? ?? 0,
      notes: json['Notes'] as String? ?? '',
      flag: json['flag'] as int? ?? 0,
      studentname: json['studentname'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "transdate": transdate,
      "studentcode": studentcode,
      "StageCode": stageCode,
      "Notes": notes,
      "flag": flag,
      "studentname": studentname,
    };
  }

  @override
  List<Object?> get props => [id, transdate, studentcode, stageCode, notes, flag, studentname];
}
