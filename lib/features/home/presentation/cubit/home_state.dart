import 'package:equatable/equatable.dart';
import 'package:my_template/core/network/status.state.dart';
import 'package:my_template/features/home/data/models/add_permissions_response_model.dart';
import 'package:my_template/features/home/data/models/add_uniform_response_model.dart';
import 'package:my_template/features/home/data/models/edit_permissions_mobile_response_model.dart';
import 'package:my_template/features/home/data/models/edit_uniform_response_model.dart';
import 'package:my_template/features/home/data/models/get_permissions_mobile_model.dart';
import 'package:my_template/features/home/data/models/get_uniform_data_model.dart';
import 'package:my_template/features/home/data/models/parent_balance_model.dart';
import 'package:my_template/features/home/data/models/parents_student_data_model.dart';
import 'package:my_template/features/home/data/models/student_absent_count_model.dart';
import 'package:my_template/features/home/data/models/student_absent_data_model.dart';
import 'package:my_template/features/home/data/models/student_balance_model.dart';
import 'package:my_template/features/home/data/models/student_course_degree_model.dart';

import '../../data/models/home_models.dart';

class HomeState extends Equatable {
  const HomeState({
    this.parentsStudentStatus = const StatusState.initial(),
    this.studentAbsentCountStatus = const StatusState.initial(),
    this.studentCourseDegreeStatus = const StatusState.initial(),
    this.studentAbsentDataStatus = const StatusState.initial(),
    this.parentBalanceStatus = const StatusState.initial(),
    this.studentBalanceStatus = const StatusState.initial(),
    this.addPermissionsStatus = const StatusState.initial(),
    this.getPermissionsStatus = const StatusState.initial(),
    this.editPermissionsStatus = const StatusState.initial(),
    this.getUniformsStatus = const StatusState.initial(),
    this.addUniformStatus = const StatusState.initial(),
    this.editUniformStatus = const StatusState.initial(),

    this.selectedStudent,
  });

  final StatusState<List<ParentsStudentData>> parentsStudentStatus;
  final StatusState<List<StudentAbsentCount>> studentAbsentCountStatus;
  final StatusState<List<StudentCourseDegree>> studentCourseDegreeStatus;
  final StatusState<List<StudentAbsentData>> studentAbsentDataStatus;
  final StatusState<List<ParentBalanceModel>> parentBalanceStatus;
  final StatusState<List<StudentBalanceModel>> studentBalanceStatus;
  final StatusState<AddPermissionsResponse> addPermissionsStatus;
  final StatusState<GetPermissionsMobile> getPermissionsStatus;
  final StatusState<EditPermissionsMobileResponse> editPermissionsStatus;
  final StatusState<AddUniformResponseModel> addUniformStatus;
  final StatusState<GetUniformDataResponse> getUniformsStatus;
  final StatusState<EditUniformResponse> editUniformStatus;
  final StudentMiniInfo? selectedStudent;

  @override
  List<Object?> get props => [
    parentsStudentStatus,
    studentAbsentCountStatus,
    selectedStudent,
    studentCourseDegreeStatus,
    studentAbsentDataStatus,
    parentBalanceStatus,
    studentBalanceStatus,
    addPermissionsStatus,
    getPermissionsStatus,
    editPermissionsStatus,
    addUniformStatus,
    getUniformsStatus,
    editUniformStatus,
  ];

  HomeState copyWith({
    StatusState<List<ParentsStudentData>>? parentsStudentStatus,
    StatusState<List<StudentAbsentCount>>? studentAbsentCountStatus,
    StatusState<List<StudentCourseDegree>>? studentCourseDegreeStatus,
    StatusState<List<StudentAbsentData>>? studentAbsentDataStatus,
    StatusState<List<ParentBalanceModel>>? parentBalanceStatus,
    StatusState<List<StudentBalanceModel>>? studentBalanceStatus,
    StatusState<AddPermissionsResponse>? addPermissionsStatus,
    StatusState<GetPermissionsMobile>? getPermissionsStatus,
    StatusState<EditPermissionsMobileResponse>? editPermissionsStatus,
    StatusState<AddUniformResponseModel>? addUniformStatus,
    StatusState<GetUniformDataResponse>? getUniformsStatus,
    StatusState<EditUniformResponse>? editUniformStatus,

    StudentMiniInfo? selectedStudent,
  }) {
    return HomeState(
      parentsStudentStatus: parentsStudentStatus ?? this.parentsStudentStatus,
      studentAbsentCountStatus: studentAbsentCountStatus ?? this.studentAbsentCountStatus,
      selectedStudent: selectedStudent ?? this.selectedStudent,
      studentCourseDegreeStatus: studentCourseDegreeStatus ?? this.studentCourseDegreeStatus,
      studentAbsentDataStatus: studentAbsentDataStatus ?? this.studentAbsentDataStatus,
      parentBalanceStatus: parentBalanceStatus ?? this.parentBalanceStatus,
      studentBalanceStatus: studentBalanceStatus ?? this.studentBalanceStatus,
      addPermissionsStatus: addPermissionsStatus ?? this.addPermissionsStatus,
      getPermissionsStatus: getPermissionsStatus ?? this.getPermissionsStatus,
      editPermissionsStatus: editPermissionsStatus ?? this.editPermissionsStatus,
      addUniformStatus: addUniformStatus ?? this.addUniformStatus,
      getUniformsStatus: getUniformsStatus ?? this.getUniformsStatus,
      editUniformStatus: editUniformStatus ?? this.editUniformStatus,
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
