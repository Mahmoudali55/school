import 'package:equatable/equatable.dart';

class AddUniformResponseModel extends Equatable {
  final bool success;
  final int id;
  final String msg;

  const AddUniformResponseModel({required this.success, required this.id, required this.msg});

  factory AddUniformResponseModel.fromJson(Map<String, dynamic> json) {
    return AddUniformResponseModel(
      success: json['success'] as bool,
      id: json['id'] as int,
      msg: json['msg'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'id': id, 'msg': msg};
  }

  @override
  List<Object?> get props => [success, id, msg];
}
