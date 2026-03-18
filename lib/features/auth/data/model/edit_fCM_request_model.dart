import 'package:equatable/equatable.dart';

class EditFCMModel extends Equatable {
  final String userId;
  final String fcm;

  const EditFCMModel({required this.userId, required this.fcm});

  factory EditFCMModel.fromJson(Map<String, dynamic> json) {
    return EditFCMModel(userId: json['userid'] ?? '', fcm: json['FCM'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'userid': userId, 'FCM': fcm};
  }

  EditFCMModel copyWith({String? userId, String? fcm}) {
    return EditFCMModel(userId: userId ?? this.userId, fcm: fcm ?? this.fcm);
  }

  @override
  List<Object?> get props => [userId, fcm];
}
