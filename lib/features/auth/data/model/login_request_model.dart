import 'package:equatable/equatable.dart';

class LoginRequestModel extends Equatable {
  final dynamic grantType;
  final String username;
  final String password;

  const LoginRequestModel({
    required this.grantType,
    required this.username,
    required this.password,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      grantType: json['grant_type'] ?? '',
      username: json['Username'] ?? '',
      password: json['Password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'grant_type': grantType, 'Username': username, 'Password': password};
  }

  @override
  List<Object?> get props => [grantType, username, password];
}
