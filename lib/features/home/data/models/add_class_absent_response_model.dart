import 'package:equatable/equatable.dart';

class AddClassAbsentResponseModel extends Equatable {
  final bool success;
  final int id;
  final String msg;

  const AddClassAbsentResponseModel({required this.success, required this.id, required this.msg});

  factory AddClassAbsentResponseModel.fromJson(Map<String, dynamic> json) {
    return AddClassAbsentResponseModel(
      success: json['success'] as bool,
      id: json['id'] as int,
      msg: json['msg'] as String,
    );
  }

  @override
  List<Object> get props => [success, id, msg];
}
