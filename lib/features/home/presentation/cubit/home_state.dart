import 'package:equatable/equatable.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/home/data/models/parents_student_data_model.dart';
import 'package:my_template/features/home/data/models/student_absent_count_model.dart';
import 'package:my_template/features/home/data/models/student_course_degree_model.dart';

import '../../data/models/home_models.dart';

class HomeState extends Equatable {
  const HomeState({
    this.parentsStudentStatus = const StatusState.initial(),
    this.studentAbsentCountStatus = const StatusState.initial(),
    this.studentCourseDegreeStatus = const StatusState.initial(),
    this.selectedStudent,
  });

  final StatusState<List<ParentsStudentData>> parentsStudentStatus;
  final StatusState<List<StudentAbsentCount>> studentAbsentCountStatus;
  final StatusState<List<StudentCourseDegree>> studentCourseDegreeStatus;
  final StudentMiniInfo? selectedStudent;

  @override
  List<Object?> get props => [
    parentsStudentStatus,
    studentAbsentCountStatus,
    selectedStudent,
    studentCourseDegreeStatus,
  ];

  HomeState copyWith({
    StatusState<List<ParentsStudentData>>? parentsStudentStatus,
    StatusState<List<StudentAbsentCount>>? studentAbsentCountStatus,
    StatusState<List<StudentCourseDegree>>? studentCourseDegreeStatus,
    StudentMiniInfo? selectedStudent,
  }) {
    return HomeState(
      parentsStudentStatus: parentsStudentStatus ?? this.parentsStudentStatus,
      studentAbsentCountStatus: studentAbsentCountStatus ?? this.studentAbsentCountStatus,
      selectedStudent: selectedStudent ?? this.selectedStudent,
      studentCourseDegreeStatus: studentCourseDegreeStatus ?? this.studentCourseDegreeStatus,
    );
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
