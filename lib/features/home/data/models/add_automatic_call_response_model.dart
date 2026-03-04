import 'package:equatable/equatable.dart';

class AddAutomaticCallResponseModel extends Equatable {
  final bool success;
  final String id;
  final String msg;

  const AddAutomaticCallResponseModel({required this.success, required this.id, required this.msg});

  factory AddAutomaticCallResponseModel.fromJson(Map<String, dynamic> json) {
    return AddAutomaticCallResponseModel(
      success: json['success'] as bool? ?? false,
      id: json['id'] as String? ?? '',
      msg: json['msg'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"success": success, "id": id, "msg": msg};
  }

  @override
  List<Object?> get props => [success, id, msg];
}
