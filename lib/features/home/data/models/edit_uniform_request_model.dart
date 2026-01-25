import 'package:equatable/equatable.dart';

class EditUniformRequestModel extends Equatable {
  final int id;
  final int studentCode;
  final int parentCode;
  final int height;
  final double weight;
  final String size;
  final String notes;

  const EditUniformRequestModel({
    required this.id,
    required this.studentCode,
    required this.parentCode,
    required this.height,
    required this.weight,
    required this.size,
    required this.notes,
  });

  factory EditUniformRequestModel.fromJson(Map<String, dynamic> json) {
    return EditUniformRequestModel(
      id: json['id'] as int,
      studentCode: json['StudentCode'] as int,
      parentCode: json['ParentCode'] as int,
      height: json['Height'] as int,
      weight: (json['Weight'] as num).toDouble(),
      size: json['Size'] as String,
      notes: json['Notes'] as String,
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
    };
  }

  @override
  List<Object?> get props => [id, studentCode, parentCode, height, weight, size, notes];
}
