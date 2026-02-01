import 'dart:convert';

import 'package:equatable/equatable.dart';

class TeacherLevelModel extends Equatable {
  final int levelCode;
  final String levelName;

  const TeacherLevelModel({required this.levelCode, required this.levelName});

  factory TeacherLevelModel.fromJson(Map<String, dynamic> json) {
    return TeacherLevelModel(
      levelCode: json['LEVEL_CODE'] as int,
      levelName: json['levelname'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'LEVEL_CODE': levelCode, 'levelname': levelName};
  }

  /// 🔹 تحويل Response كامل من الـ API إلى List<Model>
  static List<TeacherLevelModel> fromApiResponse(Map<String, dynamic> response) {
    final String dataString = response['Data'] as String;
    final List<dynamic> dataList = json.decode(dataString);

    return dataList.map((e) => TeacherLevelModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  List<Object?> get props => [levelCode, levelName];
}
