import 'package:equatable/equatable.dart';

class AddEventResponseModel extends Equatable {
  final bool success;
  final int id;
  final String msg;

  const AddEventResponseModel({required this.success, required this.id, required this.msg});

  factory AddEventResponseModel.fromJson(Map<String, dynamic> json) {
    return AddEventResponseModel(
      success: json['success'] ?? false,
      id: json['id'] ?? 0,
      msg: json['msg'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'id': id, 'msg': msg};
  }

  @override
  List<Object?> get props => [success, id, msg];
}
