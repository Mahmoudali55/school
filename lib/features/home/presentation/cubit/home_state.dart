import 'package:equatable/equatable.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/home/data/models/parents_student_data_model.dart';

import '../../data/models/home_models.dart';

class HomeState extends Equatable {
  const HomeState({this.parentsStudentStatus = const StatusState.initial()});

  final StatusState<List<ParentsStudentData>> parentsStudentStatus;
  @override
  List<Object?> get props => [parentsStudentStatus];
  HomeState copyWith({StatusState<List<ParentsStudentData>>? parentsStudentStatus}) {
    return (HomeState(parentsStudentStatus: parentsStudentStatus ?? this.parentsStudentStatus));
  }
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final HomeModel data;

  const HomeLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
