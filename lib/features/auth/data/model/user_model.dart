// lib/features/auth/data/model/user_model.dart

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String mobile;
  final String? mobileVerifiedAt;
  final String photoProfile;
  final String status;
  final int isAvailable;
  final String createdAt;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.mobile,
    required this.mobileVerifiedAt,
    required this.photoProfile,
    required this.status,
    required this.isAvailable,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    email: json['email'] as String,
    mobile: json['mobile'] as String,
    mobileVerifiedAt: json['mobile_verified_at'] as String?,
    photoProfile: json['photo_profile'] as String? ?? '',
    status: json['status'] as String,
    // trim key to handle any trailing spaces
    isAvailable: json['is_available'] is int
        ? json['is_available'] as int
        : (json['is_available '] as int? ?? 0),
    createdAt: json['created_at'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    'mobile': mobile,
    'mobile_verified_at': mobileVerifiedAt,
    'photo_profile': photoProfile,
    'status': status,
    'is_available': isAvailable,
    'created_at': createdAt,
  };

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    mobile,
    mobileVerifiedAt,
    photoProfile,
    status,
    isAvailable,
    createdAt,
  ];
}

class AuthResponseModel extends Equatable {
  final User user;
  final String token;
  final String message;
  final bool isExpired;

  const AuthResponseModel({
    required this.user,
    required this.token,
    required this.isExpired,
    required this.message,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // The API wraps payload under "data"
    final data = json['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Missing "data" field in AuthResponse');
    }
    return AuthResponseModel(
      user: User.fromJson(data['user'] as Map<String, dynamic>),
      token: data['token'] as String,
      isExpired: data['isExpired'] as bool,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'data': {
      'user': user.toJson(),
      'token': token,
      'isExpired': isExpired,
      'message': message,
    },
  };

  @override
  List<Object?> get props => [user, token, isExpired, message];
}
