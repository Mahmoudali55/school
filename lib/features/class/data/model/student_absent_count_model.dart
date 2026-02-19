import 'dart:convert';

import 'package:equatable/equatable.dart';

class StudentAbsentCountModel extends Equatable {
  final int? absentCount;

  const StudentAbsentCountModel({this.absentCount});

  factory StudentAbsentCountModel.fromJson(Map<String, dynamic> json) {
    return StudentAbsentCountModel(absentCount: json['Absentcount']);
  }

  /// لفك الـ Data اللي جاية String
  static List<StudentAbsentCountModel> listFromResponse(Map<String, dynamic> response) {
    final dataString = response['Data'];

    if (dataString == null || dataString.isEmpty) return [];

    final List decoded = jsonDecode(dataString);

    return decoded.map((e) => StudentAbsentCountModel.fromJson(e)).toList();
  }

  @override
  List<Object?> get props => [absentCount];
}
