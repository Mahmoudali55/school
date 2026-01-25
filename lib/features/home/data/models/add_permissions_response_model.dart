import 'package:equatable/equatable.dart';

class AddPermissionsResponse extends Equatable {
  final bool success;
  final int id;
  final String msg;

  const AddPermissionsResponse({required this.success, required this.id, required this.msg});

  factory AddPermissionsResponse.fromJson(Map<String, dynamic> json) {
    return AddPermissionsResponse(
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
