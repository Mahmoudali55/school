import 'package:equatable/equatable.dart';

class AddEventResponseModel extends Equatable {
  final bool success;
  final int id;
  final String msg;

  const AddEventResponseModel({required this.success, required this.id, required this.msg});

  factory AddEventResponseModel.fromJson(Map<String, dynamic> json) {
    return AddEventResponseModel(
      success: json['success'] ?? json['Success'] ?? false,
      id:
          int.tryParse(json['id']?.toString() ?? '') ??
          int.tryParse(json['ID']?.toString() ?? '') ??
          0,
      msg: json['msg'] ?? json['msg'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'id': id, 'msg': msg};
  }

  @override
  List<Object?> get props => [success, id, msg];
}
