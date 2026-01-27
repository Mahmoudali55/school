import 'package:equatable/equatable.dart';

class ChangePasswordResponseModel extends Equatable {
  final bool data;

  const ChangePasswordResponseModel({required this.data});

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponseModel(data: json['Data'] as bool);
  }

  @override
  List<Object> get props => [data];
}
