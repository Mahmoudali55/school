import 'package:equatable/equatable.dart';

class RegistrationModel extends Equatable {
  final String UserName;
  final String email;
  final int iDNO;
  final String password;

  const RegistrationModel({
    required this.UserName,
    required this.email,
    required this.iDNO,
    required this.password,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) => RegistrationModel(
    UserName: json['UserName'],
    email: json['Email'],
    iDNO: json['IDNO'],
    password: json['password'],
  );

  Map<String, dynamic> toJson() => {
    'UserName': UserName,
    'Email': email,
    'IDNO': iDNO,
    'password': password,
  };

  @override
  List<Object?> get props => [UserName, email, iDNO, password];
}
