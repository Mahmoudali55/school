import 'dart:convert';

import 'package:my_template/features/class/data/model/schedule_model.dart';

class GetTimetableResponseModel {
  final List<ScheduleModel> data;

  const GetTimetableResponseModel({required this.data});

  factory GetTimetableResponseModel.fromJson(Map<String, dynamic> json) {
    // The "Data" field is a JSON-encoded string, so we need to decode it first
    final rawData = json['Data'];
    List<ScheduleModel> items = [];

    if (rawData is String && rawData.isNotEmpty) {
      final List<dynamic> decoded = jsonDecode(rawData);
      items = decoded.map((e) => ScheduleModel.fromJson(e)).toList();
    } else if (rawData is List) {
      items = rawData.map((e) => ScheduleModel.fromJson(e)).toList();
    }

    return GetTimetableResponseModel(data: items);
  }
}
