import 'package:equatable/equatable.dart';

class AddLessonsResponse extends Equatable {
  final bool success;
  final int id;
  final String msg;

  const AddLessonsResponse({required this.success, required this.id, required this.msg});

  factory AddLessonsResponse.fromJson(Map<String, dynamic> json) {
    return AddLessonsResponse(
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
