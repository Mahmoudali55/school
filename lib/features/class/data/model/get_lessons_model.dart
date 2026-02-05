import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:my_template/features/class/data/model/lesson_item_model.dart';

class GetLessonsModel extends Equatable {
  final List<LessonItemModel> lessons;

  const GetLessonsModel({required this.lessons});

  factory GetLessonsModel.fromJson(Map<String, dynamic> json) {
    final String dataString = json['Data'] ?? '[]';

    final List decodedList = jsonDecode(dataString);

    return GetLessonsModel(lessons: decodedList.map((e) => LessonItemModel.fromJson(e)).toList());
  }

  @override
  List<Object?> get props => [lessons];
}
