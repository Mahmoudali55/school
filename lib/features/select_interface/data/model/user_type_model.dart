import 'package:equatable/equatable.dart';

class UserTypeModel extends Equatable {
  final String id;
  final String title;
  final String icon;

  const UserTypeModel({required this.id, required this.title, required this.icon});

  @override
  List<Object?> get props => [id, title, icon];
}
