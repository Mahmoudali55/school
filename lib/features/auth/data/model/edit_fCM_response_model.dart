import 'package:equatable/equatable.dart';

class EditFCMResponseModel extends Equatable {
  final bool success;
  final String message;

  const EditFCMResponseModel({required this.success, required this.message});

  factory EditFCMResponseModel.fromJson(Map<String, dynamic> json) {
    return EditFCMResponseModel(success: json['success'] ?? false, message: json['msg'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'msg': message};
  }

  @override
  List<Object?> get props => [success, message];
}
