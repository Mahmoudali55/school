import 'dart:convert';

import 'package:equatable/equatable.dart';

class LevelModel extends Equatable {
  final int levelCode;
  final String levelName;

  const LevelModel({required this.levelCode, required this.levelName});

  /// من JSON Map لكائن LevelModel
  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(levelCode: json['LEVEL_CODE'] ?? 0, levelName: json['levelname'] ?? '');
  }

  /// لتحويل كائن LevelModel إلى JSON Map
  Map<String, dynamic> toJson() {
    return {'LEVEL_CODE': levelCode, 'levelname': levelName};
  }

  /// لتحويل JSON string كامل لقائمة من LevelModel
  static List<LevelModel> listFromJson(String jsonString) {
    final decoded = json.decode(jsonString);
    if (decoded is List) {
      return decoded.map((e) => LevelModel.fromJson(e)).toList();
    } else if (decoded is Map<String, dynamic>) {
      final data = decoded['Data'];
      if (data is String) {
        final List<dynamic> dataList = json.decode(data);
        return dataList.map((e) => LevelModel.fromJson(e)).toList();
      } else if (data is List) {
        return data.map((e) => LevelModel.fromJson(e)).toList();
      }
    }
    return [];
  }

  /// Equatable props
  @override
  List<Object?> get props => [levelCode];
}
