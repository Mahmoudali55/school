import 'package:equatable/equatable.dart';

class EditUniformResponse extends Equatable {
  final bool success;
  final String msg;

  const EditUniformResponse({required this.success, required this.msg});

  factory EditUniformResponse.fromJson(Map<String, dynamic> json) {
    return EditUniformResponse(success: json['success'] as bool, msg: json['msg'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'msg': msg};
  }

  @override
  List<Object?> get props => [success, msg];
}
