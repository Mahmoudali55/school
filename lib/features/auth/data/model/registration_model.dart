import 'package:equatable/equatable.dart';

class RegistrationModel extends Equatable {
  final String userName;
  final String email;
  final String idNo;
  final String password;
  final String? fcm;

  const RegistrationModel({
    required this.userName,
    required this.email,
    required this.idNo,
    required this.password,
    this.fcm,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      userName: json['UserName'] ?? '',
      email: json['Email'] ?? '',
      idNo: json['IDNO'] ?? '',
      password: json['password'] ?? '',
      fcm: json['FCM'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'UserName': userName, 'Email': email, 'IDNO': idNo, 'password': password, 'FCM': fcm};
  }

  @override
  List<Object?> get props => [userName, email, idNo, password, fcm];
}
