import 'package:equatable/equatable.dart';

class EditPermissionsMobileResponse extends Equatable {
  final bool success;
  final String msg;

  const EditPermissionsMobileResponse({required this.success, required this.msg});

  factory EditPermissionsMobileResponse.fromJson(Map<String, dynamic> json) {
    return EditPermissionsMobileResponse(
      success: json['success'] as bool,
      msg: json['msg'] as String,
    );
  }

  @override
  List<Object?> get props => [success, msg];
}
