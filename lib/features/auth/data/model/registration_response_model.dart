import 'package:equatable/equatable.dart';

class RegistrationResponse extends Equatable {
  final bool data;

  const RegistrationResponse({required this.data});

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(data: json['Data'] as bool);
  }

  Map<String, dynamic> toJson() => {'Data': data};

  @override
  List<Object?> get props => [data];
}
