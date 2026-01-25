import 'dart:convert';

import 'package:equatable/equatable.dart';

class GetUniformDataResponse extends Equatable {
  final List<UniformItem> data;

  const GetUniformDataResponse({required this.data});

  factory GetUniformDataResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['Data'] as String;
    final List<dynamic> parsedList = jsonDecode(rawData);
    final List<UniformItem> items = parsedList.map((e) => UniformItem.fromJson(e)).toList();
    return GetUniformDataResponse(data: items);
  }

  Map<String, dynamic> toJson() {
    final String encodedData = jsonEncode(data.map((e) => e.toJson()).toList());
    return {'Data': encodedData};
  }

  @override
  List<Object?> get props => [data];
}

class UniformItem extends Equatable {
  final int id;
  final String studentCode;
  final String parentCode;
  final int height;
  final double weight;
  final String size;
  final String notes;
  final String studentName;

  const UniformItem({
    required this.id,
    required this.studentCode,
    required this.parentCode,
    required this.height,
    required this.weight,
    required this.size,
    required this.notes,
    required this.studentName,
  });

  factory UniformItem.fromJson(Map<String, dynamic> json) {
    return UniformItem(
      id: json['id'] as int? ?? 0,
      studentCode: json['StudentCode']?.toString() ?? "",
      parentCode: json['ParentCode']?.toString() ?? "",
      height: json['Height'] as int? ?? 0,
      weight: (json['Weight'] as num?)?.toDouble() ?? 0.0,
      size: json['Size']?.toString() ?? "",
      notes: json['Notes']?.toString() ?? "",
      studentName: json['s_name']?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'StudentCode': studentCode,
      'ParentCode': parentCode,
      'Height': height,
      'Weight': weight,
      'Size': size,
      'Notes': notes,
      's_name': studentName,
    };
  }

  @override
  List<Object?> get props => [
    id,
    studentCode,
    parentCode,
    height,
    weight,
    size,
    notes,
    studentName,
  ];
}
