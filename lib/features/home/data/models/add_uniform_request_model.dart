import 'package:equatable/equatable.dart';

class AddUniformRequestModel extends Equatable {
  final int studentCode;
  final int parentCode;
  final int height;
  final int weight;
  final String size;
  final String notes;

  const AddUniformRequestModel({
    required this.studentCode,
    required this.parentCode,
    required this.height,
    required this.weight,
    required this.size,
    required this.notes,
  });

  factory AddUniformRequestModel.fromJson(Map<String, dynamic> json) {
    return AddUniformRequestModel(
      studentCode: json['StudentCode'] as int,
      parentCode: json['ParentCode'] as int,
      height: json['Height'] as int,
      weight: json['Weight'] as int,
      size: json['Size'] as String,
      notes: json['Notes'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'StudentCode': studentCode,
      'ParentCode': parentCode,
      'Height': height,
      'Weight': weight,
      'Size': size,
      'Notes': notes,
    };
  }

  @override
  List<Object?> get props => [studentCode, parentCode, height, weight, size, notes];
}
