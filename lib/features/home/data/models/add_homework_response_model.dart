import 'package:equatable/equatable.dart';

class AddHomeworkResponseModel extends Equatable {
  final bool success;
  final int id;
  final String msg;

  const AddHomeworkResponseModel({required this.success, required this.id, required this.msg});

  factory AddHomeworkResponseModel.fromJson(Map<String, dynamic> json) {
    return AddHomeworkResponseModel(
      success: json['success'] as bool,
      id: json['id'] as int,
      msg: json['msg'] as String,
    );
  }

  @override
  List<Object> get props => [success, id, msg];
}
