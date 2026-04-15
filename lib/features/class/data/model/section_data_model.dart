import 'dart:convert';

import 'package:equatable/equatable.dart';

class SectionDataModel extends Equatable {
  final int sectionCode;
  final String sectionName;

  const SectionDataModel({required this.sectionCode, required this.sectionName});

  /// تحويل من JSON إلى كائن
  factory SectionDataModel.fromJson(Map<String, dynamic> json) {
    return SectionDataModel(
      sectionCode: (json['sectioncode'] as num?)?.toInt() ?? 0,
      sectionName: json['sectionname'] as String? ?? '',
    );
  }

  /// تحويل من كائن إلى JSON
  Map<String, dynamic> toJson() {
    return {'sectioncode': sectionCode, 'sectionname': sectionName};
  }

  /// تحويل JSON String كامل (مثال من الـ "Data") إلى List<SectionDataModel>
  static List<SectionDataModel> listFromJsonString(String jsonString) {
    final data = json.decode(jsonString) as List<dynamic>;
    return data.map((e) => SectionDataModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  List<Object?> get props => [sectionCode, sectionName];
}
