import 'package:equatable/equatable.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/class/data/model/class_models.dart';
import 'package:my_template/features/class/data/model/home_work_model.dart';

class ClassState extends Equatable {
  final StatusState<List<ClassModel>> classesStatus;
  final StatusState<List<HomeWorkModel>> homeWorkStatus;

  const ClassState({
    this.classesStatus = const StatusState.initial(),
    this.homeWorkStatus = const StatusState.initial(),
  });

  @override
  List<Object?> get props => [classesStatus, homeWorkStatus];

  ClassState copyWith({
    StatusState<List<ClassModel>>? classesStatus,
    StatusState<List<HomeWorkModel>>? homeWorkStatus,
  }) {
    return ClassState(
      classesStatus: classesStatus ?? this.classesStatus,
      homeWorkStatus: homeWorkStatus ?? this.homeWorkStatus,
    );
  }
}

class ClassInitial extends ClassState {}

class ClassLoading extends ClassState {}

class ClassLoaded extends ClassState {
  final List<ClassModel> classes;

  const ClassLoaded(this.classes);

  @override
  List<Object?> get props => [classes];
}

class ClassError extends ClassState {
  final String message;

  const ClassError(this.message);

  @override
  List<Object?> get props => [message];
}
